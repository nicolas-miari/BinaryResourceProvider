import Foundation
import CoreImage

public protocol BinaryResourceProvider {

  /**
   Returns a directory file wrapper representing the current contents of the provider's cache, for
   persistence on disk.

   The resource provider can later be faithfully restored by calling the factory method
   `loadResourceProvider(from:)` and passing the same directory wrapper returned here.
   */
  func directoryWrapper() -> FileWrapper

  /**
   Caches the passed image data and returns a unique identifier that can later be used to retrieve
   it
   */
  func add(_ image: CGImage) -> String

  /**
   Returns the image previously cached and assigned the specified identifier. Throws if an image
   cannot be found on the cache.
   */
  func image(identifier: String) throws -> CGImage
}

// MARK: - Supporting Types

public enum BinaryResourceError: LocalizedError {
  case resourceNotFound
  case dataCorrupted
}
