import XCTest
import CoreImage
import CoreGraphics
import ImageUtils

@testable import BinaryResourceProvider

final class BinaryResourceProviderTests: XCTestCase {

  func testAddRetrieve() throws {
    // GIVEN
    let provider = BinaryResourceProviderFactory.newResourceProvider()

    // WHEN
    let image = try CGImage.createSolid(size: CGSize(width: 20, height: 20), color: CGColor.white)
    let identifier = provider.add(image)

    // THEN
    XCTAssertIdentical(image, try provider.image(identifier: identifier))
  }

  func testLoadFromFileWrapper() throws {
    // GIVEN
    let image = try CGImage.createSolid(size: CGSize(width: 20, height: 20), color: CGColor.white)
    let data = try image.pngData()
    let identifier = UUID().uuidString
    let file = FileWrapper(regularFileWithContents: data)
    let directory = FileWrapper(directoryWithFileWrappers: [identifier: file])

    // WHEN
    let provider = try BinaryResourceProviderFactory.loadResourceProvider(from: directory)

    // THEN
    let retrievedImage = try provider.image(identifier: identifier)
    XCTAssertEqual(retrievedImage.width, image.width)
    XCTAssertEqual(retrievedImage.height, image.height)
    XCTAssertEqual(try retrievedImage.pngData(), data)
  }

  func testImageNotFound() {
    // GIVEN
    let provider = BinaryResourceProviderFactory.newResourceProvider()

    // THEN
    XCTAssertThrowsError(try provider.image(identifier: "ABCDEF"))
  }

  func testLoadEmptyDirectory() throws {
    let directory = FileWrapper(directoryWithFileWrappers: [:])
    _ = try BinaryResourceProviderFactory.loadResourceProvider(from: directory)
  }

  func testRecoverFromDirectory() throws {
    // GIVEN
    let provider = BinaryResourceProviderFactory.newResourceProvider()
    let image = try CGImage.createSolid(size: CGSize(width: 20, height: 20), color: CGColor.white)
    let identifier = provider.add(image)

    // WHEN
    let directory = provider.directoryWrapper()
    let restoredProvider = try BinaryResourceProviderFactory.loadResourceProvider(from: directory)

    // THEN
    let retrievedImage = try restoredProvider.image(identifier: identifier)
    XCTAssertEqual(try retrievedImage.pngData(), try image.pngData())
  }
}
