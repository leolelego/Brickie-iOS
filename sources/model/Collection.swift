//
//  Collection.swift
//  BrickSet
//
//  Created by Work on 03/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import Combine
enum CollectionFilter : Equatable{
    case wanted
    case owned
    case search(String)
}
class UserCollection : ObservableObject{
    @Published private var sets = [LegoSet]()
    @Published var minifigs = [LegoMinifig]()
    @Published var searchSetsText = ""
    private var searchCancellable: AnyCancellable?
    @Published var isLoadingData : Bool = false

    init(){
        isLoadingData = false
        searchCancellable = $searchSetsText
            .handleEvents(receiveOutput: { [weak self] _ in self?.isLoadingData = true })

            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink{ _ in
                if self.searchSetsText.isEmpty {
                    self.setsFilter = .owned
                    self.isLoadingData = false
                } else {
                    API.search(text: self.searchSetsText)
                    self.setsFilter = .search(self.searchSetsText)
                    
                    
                }
        }
        
        
        
    }
    
    func append(_ new:[LegoSet]){
        objectWillChange.send()
        for set in new {
            if let idx = sets.firstIndex(of: set){
                sets[idx].update(from: set)
            } else {
                sets.append(set)
            }
        }
    }
    // Remove set taht are NOT wanted
    func updateWanted(with wanted:[LegoSet]){
        objectWillChange.send()
        for set in sets {
            set.collection.wanted = wanted.contains(set)
        }
    }
    func updateOwned(with owned:[LegoSet]){
        objectWillChange.send()
        for set in sets {
            set.collection.owned = owned.contains(set)
        }
    }
    
    var setsFilter : CollectionFilter = .owned {
        didSet{
            objectWillChange.send()
        }
    }
    
    var setsUI : [LegoSet] {
        switch setsFilter {
        case .wanted:
            return  sets.filter({$0.collection.wanted == true})
        case .owned:
            return sets.filter({$0.collection.owned == true})
        case .search(let str):
            return sets.filter({$0.match(str)})
        }
    }
    
}
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
