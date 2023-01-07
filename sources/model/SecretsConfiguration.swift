import Foundation

private extension ProcessInfo {
    static var isUnitTest: Bool {
        processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}

enum SecretsConfiguration {
    private static let debugBrickSetApiKey = "mock-api-key"
    static var apiKey: String {
#if DEBUG
    if ProcessInfo.isUnitTest {
        return debugBrickSetApiKey
    }
#endif
    return BrickSetApiKey
    }
}
