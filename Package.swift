// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BinaryResourceProvider",
    platforms: [
      .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BinaryResourceProvider",
            targets: ["BinaryResourceProvider"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
      .package(url: "https://github.com/nicolas-miari/ImageUtils.git", from: "0.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BinaryResourceProvider",
            dependencies: [
              .product(name: "ImageUtils", package: "ImageUtils"),
            ]),
        .testTarget(
            name: "BinaryResourceProviderTests",
            dependencies: [
              "BinaryResourceProvider",
              .product(name: "ImageUtils", package: "ImageUtils"),
            ]),
    ]
)
