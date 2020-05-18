// original Github but optimized for persistence
import UIKit

struct ImageCache {
    private var dataCache = DataCache()
    subscript(_ key: URL) -> UIImage? {
        get {
            guard let data =  dataCache[key] else {return nil}
            return UIImage(data: data)
        }
        set {
            dataCache[key] = newValue?.pngData()
        }
    }
}

struct DataCache {
    private let cache = NSCache<NSURL, NSData>()
    private var disk = PersistentData()
    
    subscript(_ key: URL) -> Data? {
        get {
            if let loc =  cache.object(forKey: key as NSURL){
                return loc as Data
            }
            return disk[key]
            
        }
        set {
            guard let val = newValue
                else { cache.removeObject(forKey: key as NSURL);return}
            
            cache.setObject(val as NSData, forKey: key as NSURL)
            disk[key] = val
            
            
        }
    }
}
struct PersistentData {
    private let filemanager = FileManager()
    let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as URL
    
    subscript(_ key: URL) -> Data? {
        get {
            return try? Data(contentsOf: documentsUrl.appendingPathComponent(key.lastPathComponent))
        }
        set {
            let path = documentsUrl.appendingPathComponent(key.lastPathComponent)
            DispatchQueue.global().async{
                do {
                    try newValue?.write(to: path)
                } catch {
                    logerror(error)
                }
                
            }
            
            
        }
    }
}
