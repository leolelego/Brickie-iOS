
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

