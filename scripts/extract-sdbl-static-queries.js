#!/usr/bin/env node

const fs = require("node:fs");
const path = require("node:path");
const process = require("node:process");

const Parser = require("tree-sitter");
const { sdbl } = require("../bindings/node");

const USAGE = `Usage:
  node scripts/extract-sdbl-static-queries.js [--max-errors N] [--relative-to DIR] <file-or-dir>...

Extracts static BSL string literals that look like standalone SDBL query texts,
parses them with the local sdbl Node binding, and exits with:
  0 when all extracted candidates parse without errors
  1 when at least one extracted candidate has parser errors
  2 for invalid input or filesystem errors
`;

function parseArgs(argv) {
  const args = {
    paths: [],
    maxErrors: 50,
    relativeTo: process.cwd(),
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--max-errors") {
      index += 1;
      if (index >= argv.length) {
        throw new Error("--max-errors requires a number");
      }
      args.maxErrors = Number.parseInt(argv[index], 10);
      if (!Number.isInteger(args.maxErrors) || args.maxErrors < 0) {
        throw new Error("--max-errors must be a non-negative integer");
      }
    } else if (arg === "--relative-to") {
      index += 1;
      if (index >= argv.length) {
        throw new Error("--relative-to requires a directory");
      }
      args.relativeTo = path.resolve(argv[index]);
    } else if (arg === "--help" || arg === "-h") {
      console.log(USAGE);
      process.exit(0);
    } else if (arg.startsWith("--")) {
      throw new Error(`Unknown option: ${arg}`);
    } else {
      args.paths.push(arg);
    }
  }

  if (args.paths.length === 0) {
    throw new Error("At least one file or directory is required");
  }

  return args;
}

function collectBslFiles(inputPaths) {
  const files = [];
  const seen = new Set();

  function visit(inputPath) {
    const resolved = path.resolve(inputPath);
    const stat = fs.statSync(resolved);
    if (stat.isDirectory()) {
      for (const entry of fs.readdirSync(resolved, { withFileTypes: true })) {
        visit(path.join(resolved, entry.name));
      }
      return;
    }

    if (!stat.isFile() || !resolved.toLowerCase().endsWith(".bsl")) {
      return;
    }

    if (!seen.has(resolved)) {
      seen.add(resolved);
      files.push(resolved);
    }
  }

  for (const inputPath of inputPaths) {
    visit(inputPath);
  }

  files.sort();
  return files;
}

function readBslString(source, startIndex) {
  let index = startIndex + 1;
  let value = "";

  while (index < source.length) {
    const char = source[index];
    if (char === "\"") {
      if (source[index + 1] === "\"") {
        value += "\"";
        index += 2;
        continue;
      }
      return {
        value,
        endIndex: index + 1,
      };
    }

    value += char;
    index += 1;
  }

  return null;
}

function normalizeBslString(value) {
  return value
    .replace(/^\uFEFF/, "")
    .replace(/\r\n?/g, "\n")
    .split("\n")
    .map((line, index) => (index === 0 ? line : line.replace(/^\s*\| ?/, "")))
    .join("\n")
    .replace(/[ \t]+$/gm, "")
    .trim();
}

function positionForIndex(source, targetIndex) {
  let row = 1;
  let column = 1;

  for (let index = 0; index < targetIndex; index += 1) {
    if (source[index] === "\n") {
      row += 1;
      column = 1;
    } else {
      column += 1;
    }
  }

  return { row, column };
}

function extractQueryCandidates(file, source) {
  const candidates = [];

  for (let index = 0; index < source.length; index += 1) {
    if (source[index] !== "\"") {
      continue;
    }

    const literal = readBslString(source, index);
    if (!literal) {
      break;
    }

    const text = normalizeBslString(literal.value);
    if (/^(ВЫБРАТЬ|УНИЧТОЖИТЬ)(?:\s|$)/i.test(text)) {
      candidates.push({
        file,
        position: positionForIndex(source, index),
        text,
      });
    }

    index = literal.endIndex - 1;
  }

  return candidates;
}

function firstErrorNode(node) {
  if (node.type === "ERROR" || node.isMissing) {
    return node;
  }

  for (let index = 0; index < node.childCount; index += 1) {
    const found = firstErrorNode(node.child(index));
    if (found) {
      return found;
    }
  }

  return null;
}

function snippet(source, node) {
  if (!node) {
    return "<unknown>";
  }

  const raw = source
    .slice(node.startIndex, Math.min(node.endIndex, node.startIndex + 80))
    .replace(/\r/g, "\\r")
    .replace(/\n/g, "\\n")
    .replace(/\t/g, "\\t");

  return raw.length > 0 ? raw : "<missing>";
}

function main() {
  let args;
  try {
    args = parseArgs(process.argv.slice(2));
  } catch (error) {
    console.error(error.message);
    console.error(USAGE);
    return 2;
  }

  let files;
  try {
    files = collectBslFiles(args.paths);
  } catch (error) {
    console.error(error.message);
    return 2;
  }

  if (files.length === 0) {
    console.error("No .bsl files found");
    return 2;
  }

  const parser = new Parser();
  parser.setLanguage(sdbl);

  const candidates = [];
  for (const file of files) {
    const source = fs.readFileSync(file, "utf8");
    candidates.push(...extractQueryCandidates(file, source));
  }

  const errors = [];
  let parsedWithoutErrors = 0;

  for (const candidate of candidates) {
    const tree = parser.parse(candidate.text);
    if (!tree.rootNode.hasError) {
      parsedWithoutErrors += 1;
      continue;
    }

    errors.push({
      candidate,
      errorNode: firstErrorNode(tree.rootNode),
    });
  }

  console.log(`Scanned BSL files: ${files.length}.`);
  console.log(`Candidate static query texts: ${candidates.length}.`);
  console.log(`Parsed without errors: ${parsedWithoutErrors}.`);
  console.log(`Parser errors: ${errors.length}.`);

  for (const item of errors.slice(0, args.maxErrors)) {
    const displayPath = path.relative(args.relativeTo, item.candidate.file)
      || item.candidate.file;
    const node = item.errorNode;
    const row = node ? node.startPosition.row + 1 : 0;
    const column = node ? node.startPosition.column + 1 : 0;
    console.log(
      `${displayPath}:${item.candidate.position.row}:${item.candidate.position.column}`
        + `: query ${row}:${column}: ${node ? node.type : "ERROR"}`
        + `: ${snippet(item.candidate.text, node)}`,
    );
  }

  if (errors.length > args.maxErrors) {
    console.log(`... ${errors.length - args.maxErrors} more candidate(s) with parser errors`);
  }

  return errors.length === 0 ? 0 : 1;
}

process.exitCode = main();
