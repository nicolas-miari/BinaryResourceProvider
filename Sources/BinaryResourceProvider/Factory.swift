import Foundation

/**
 The purpose of the factory is to hide the concrete implementation of the BinaryResourceProvider
 protocol.

 Clients of the service should obtain an opaque instance from the fatory and operate on it.
 */
public final class BinaryResourceProviderFactory {

  public static func newResourceProvider() -> some BinaryResourceProvider {
    return BinaryResourceProviderImplementation()
  }

  public static func loadResourceProvider(from directory: FileWrapper) throws -> some BinaryResourceProvider {
    let provider = BinaryResourceProviderImplementation()
    try provider.loadContents(from: directory)
    return provider
  }
}
