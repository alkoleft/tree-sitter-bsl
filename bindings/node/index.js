const root = require("path").join(__dirname, "..", "..");

module.exports =
  typeof process.versions.bun === "string"
    // Support `bun build --compile` by being statically analyzable enough to find the .node file at build-time
    ? require(`../../prebuilds/${process.platform}-${process.arch}/tree-sitter-bsl.node`)
    : require("node-gyp-build")(root);

try {
  module.exports.nodeTypeInfo = require("../../grammars/bsl/src/node-types.json");
  module.exports.sdbl.nodeTypeInfo = require("../../grammars/sdbl/src/node-types.json");
} catch (_) {}
