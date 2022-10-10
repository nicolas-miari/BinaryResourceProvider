import XCTest
import CoreImage
import CoreGraphics
import ImageUtils
import UniqueIdentifierProvider

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

  func testImageNotFound() {
    // GIVEN
    let provider = BinaryResourceProviderFactory.newResourceProvider(
      identifierProvider: UniqueIdentifierProviderFactory.newIdentifierProvider())

    // THEN
    XCTAssertThrowsError(try provider.image(identifier: "ABCDEF"))
  }

  func testLoadEmptyDirectoryFails() throws {
    // GIVEN
    let directory = FileWrapper(directoryWithFileWrappers: [:])

    // THEN
    XCTAssertThrowsError(try BinaryResourceProviderFactory.loadResourceProvider(from: directory))
  }

  func testRecoverFromDirectoryPreservesContents() throws {
    // GIVEN
    let provider = BinaryResourceProviderFactory.newResourceProvider()
    let image = try CGImage.createSolid(size: CGSize(width: 20, height: 20), color: CGColor.white)
    let identifier = provider.add(image)

    // WHEN
    let directory = try provider.directoryWrapper()
    let restoredProvider = try BinaryResourceProviderFactory.loadResourceProvider(from: directory)

    // THEN
    let retrievedImage = try restoredProvider.image(identifier: identifier)
    XCTAssertEqual(try retrievedImage.pngData(), try image.pngData())
  }
}
