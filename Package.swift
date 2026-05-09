// swift-tools-version:5.3

import Foundation
import PackageDescription

var sources = ["grammars/bsl/src/parser.c"]
if FileManager.default.fileExists(atPath: "grammars/bsl/src/scanner.c") {
    sources.append("grammars/bsl/src/scanner.c")
}
var resources: [Resource] = []
if FileManager.default.fileExists(atPath: "grammars/bsl/queries") {
    resources.append(.copy("grammars/bsl/queries"))
}

let package = Package(
    name: "TreeSitterBsl",
    products: [
        .library(name: "TreeSitterBsl", targets: ["TreeSitterBsl"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tree-sitter/swift-tree-sitter", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "TreeSitterBsl",
            dependencies: [],
            path: ".",
            sources: sources,
            resources: resources,
            publicHeadersPath: "bindings/swift",
            cSettings: [.headerSearchPath("grammars/bsl/src")]
        ),
        .testTarget(
            name: "TreeSitterBslTests",
            dependencies: [
                "SwiftTreeSitter",
                "TreeSitterBsl",
            ],
            path: "bindings/swift/TreeSitterBslTests"
        )
    ],
    cLanguageStandard: .c11
)
