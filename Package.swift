// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FindMyIPLibraryProject",
    platforms: [
      // Only add support for iOS 15 and up.
      .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FindMyIPLibraryProject",
            targets: ["FindMyIPLibraryProject"]),
    ],
    dependencies: [
           // Dependencies declare other packages that this package depends on.
           .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
       ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FindMyIPLibraryProject",dependencies: [.product(name: "Alamofire",package: "Alamofire")]),
        .testTarget(
            name: "FindMyIPLibraryProjectTests",
            dependencies: ["FindMyIPLibraryProject"]),
    ]
    

)
