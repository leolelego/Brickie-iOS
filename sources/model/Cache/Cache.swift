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
    func free(){
        cache.removeAllObjects()
    }
}
struct PersistentData {
    private let filemanager = FileManager()
    let documentsUrl = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: "group.family.homework.brickset")!
    
//
//    FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as URL
    
    
    
    subscript(_ key: URL) -> Data? {
        get {
            return try? Data(contentsOf: documentsUrl.appendingPathComponent(key.lastPathComponent))
        }
        set {
            let path = documentsUrl.appendingPathComponent(key.lastPathComponent)
            DispatchQueue.global().async{
                do {
                    let userDefaults = UserDefaults.standard
                    var array = userDefaults.array(forKey: "file_cache")  ?? [URL]()

                    if newValue == nil {
                        try FileManager.default.removeItem(at: path)
                        
                        if let idx = array.firstIndex(where: {($0 as? URL) == key}){
                            array.remove(at: idx)
                        }
                        
                        
                    } else {
                        try newValue?.write(to: path)
                        array.append(key)
                        
                        print("Save File at : \(path)")
                    }
                    userDefaults.set(key, forKey: "file_cache")
                    userDefaults.synchronize()
                    
                } catch {
                    logerror(error)
                }
                
            }
        }
    }
    
    func free(){
        let array = UserDefaults.standard.array(forKey: "file_cache") as? [URL]  ?? [URL]()
        for item in array {
           let path = documentsUrl.appendingPathComponent(item.lastPathComponent)
            
            try? FileManager.default.removeItem(at: path)
        }
        
    }
}
