
import SwiftUI

struct DataCacheKey: EnvironmentKey {
    static let defaultValue: DataCache = DataCache()
}

extension EnvironmentValues {
    var dataCache: DataCache {
        get { self[DataCacheKey.self] }
        set { self[DataCacheKey.self] = newValue }
    }
}

struct ConfgifurationKey: EnvironmentKey {
    static let defaultValue: Configuration = Configuration()
}

extension EnvironmentValues {
    var config: Configuration {
        get { self[ConfgifurationKey.self] }
        set { self[ConfgifurationKey.self] = newValue }
    }
}
//struct UserCollectionKey: EnvironmentKey {
//    static let defaultValue: UserCollection = UserCollection()
//}
//
//extension EnvironmentValues {
//    var collection: UserCollection {
//        get { self[UserCollectionKey.self] }
//        set { self[UserCollectionKey.self] = newValue }
//    }
//}
