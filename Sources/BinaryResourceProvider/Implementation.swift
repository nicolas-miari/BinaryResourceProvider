import Foundation
import AppKit     // for CGImage and NSBitmapImageRep
import ImageUtils

internal class BinaryResourceProviderImplementation: BinaryResourceProvider {

  // MARK: - BinaryResourceProvider Interface

  func directoryWrapper() -> FileWrapper {
    let fileWrappers: [String: FileWrapper] = cache.compactMapValues { image in
      guard let data = try? image.pngData() else { return nil }
      return FileWrapper(regularFileWithContents: data)
    }
    return FileWrapper(directoryWithFileWrappers: fileWrappers)
  }

  func add(_ image: CGImage) -> String {
    let identifier = UUID().uuidString
    cache[identifier] = image
    return identifier
  }

  func image(identifier: String) throws -> CGImage {
    guard let image = cache[identifier] else {
      throw BinaryResourceError.resourceNotFound
    }
    return image
  }

  // MARK: - Internal Interface

  internal func loadContents(from directory: FileWrapper) throws {
    guard let children = directory.fileWrappers else {
      return
    }

    try children.forEach { identifier, file in
      guard let data = file.regularFileContents else {
        throw BinaryResourceError.dataCorrupted
      }
      guard let bitmapRep = NSBitmapImageRep(data: data) else {
        throw BinaryResourceError.dataCorrupted
      }
      guard let image = bitmapRep.cgImage else {
        throw BinaryResourceError.dataCorrupted
      }
      cache[identifier] = image
    }
  }

  // MARK: - Private

  private var cache: [String: CGImage] = [:]
}
