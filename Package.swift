// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BinaryResourceProvider",
  platforms: [
    .macOS(.v11)
  ],
  products: [
    .library(
      name: "BinaryResourceProvider",
      targets: ["BinaryResourceProvider"]),
  ],
  dependencies: [
    .package(url: "https://github.com/nicolas-miari/ImageUtils.git", from: "0.0.1"),
    .package(url: "https://github.com/nicolas-miari/UniqueIdentifierProvider.git", from: "0.0.3"),
  ],
  targets: [
    .target(
      name: "BinaryResourceProvider",
      dependencies: [
        .product(name: "ImageUtils", package: "ImageUtils"),
        .product(name: "UniqueIdentifierProvider", package: "UniqueIdentifierProvider"),
      ]),
    .testTarget(
      name: "BinaryResourceProviderTests",
      dependencies: [
        "BinaryResourceProvider",
        .product(name: "ImageUtils", package: "ImageUtils"),
      ]),
  ]
)
