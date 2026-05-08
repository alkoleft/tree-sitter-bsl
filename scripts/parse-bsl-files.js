#!/usr/bin/env node

const fs = require("node:fs");
const path = require("node:path");
const process = require("node:process");

const Parser = require("tree-sitter");
const BSL = require("../bindings/node");

const USAGE = `Usage:
  node scripts/parse-bsl-files.js [--stdin0] [--max-errors N] [--relative-to DIR] <file-or-dir>...

Parses .bsl files with the local tree-sitter-bsl Node binding and exits with:
  0 when all files parse without errors
  1 when at least one parser error is found
  2 for invalid input or filesystem errors
`;

function parseArgs(argv) {
  const args = {
    paths: [],
    stdin0: false,
    maxErrors: 50,
    relativeTo: process.cwd(),
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--stdin0") {
      args.stdin0 = true;
    } else if (arg === "--max-errors") {
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

  if (args.stdin0) {
    const input = fs.readFileSync(0);
    args.paths.push(
      ...input
        .toString("utf8")
        .split("\0")
        .filter((item) => item.length > 0),
    );
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
  const raw = source
    .slice(node.startIndex, Math.min(node.endIndex, node.startIndex + 80))
    .replace(/\r/g, "\\r")
    .replace(/\n/g, "\\n")
    .replace(/\t/g, "\\t");

  if (raw.length > 0) {
    return raw;
  }

  return "<missing>";
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
  parser.setLanguage(BSL);

  const errors = [];
  for (const file of files) {
    const source = fs.readFileSync(file, "utf8");
    const tree = parser.parse(source);
    if (!tree.rootNode.hasError) {
      continue;
    }

    const errorNode = firstErrorNode(tree.rootNode);
    errors.push({
      file,
      errorNode,
      source,
    });
  }

  console.log(`Parsed ${files.length} .bsl file(s).`);
  console.log(`Files with parser errors: ${errors.length}.`);

  for (const item of errors.slice(0, args.maxErrors)) {
    const node = item.errorNode;
    const displayPath = path.relative(args.relativeTo, item.file) || item.file;
    if (!node) {
      console.log(`${displayPath}: parser error`);
      continue;
    }

    const row = node.startPosition.row + 1;
    const column = node.startPosition.column + 1;
    console.log(
      `${displayPath}:${row}:${column}: ${node.type}: ${snippet(item.source, node)}`,
    );
  }

  if (errors.length > args.maxErrors) {
    console.log(`... ${errors.length - args.maxErrors} more file(s) with parser errors`);
  }

  return errors.length === 0 ? 0 : 1;
}

process.exitCode = main();
