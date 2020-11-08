//
//  SetsListView.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct SetsListView: View {
    

    
    var items : [LegoSet]
    @EnvironmentObject private var  store : Store
    @Binding var sorter : LegoListSorter
    @Binding var filter : LegoListFilter 
    
    var body: some View {
        
        Group {
            
            if setsToShow.count == 0 {
                Spacer()
                
                HStack(alignment: .center){
                    Spacer()
                    if store.isLoadingData {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("sets.noitems").font(.largeTitle).bold()

                    }
                    Spacer()
                }
                if store.sets.filter({$0.collection.owned}).count == 0 {
                    HStack(alignment: .center){
                        Spacer()
                        Text("sets.firstsync").multilineTextAlignment(.center).font(.subheadline)
                        Spacer()
                    }
                }
                
            } else {
                
                if isDebug{
                    HStack{
                        Spacer()
                        Text(String(setsToShow.count)).roundText
                        Spacer()
                    }
                }
                ForEach(sections(for:  setsToShow ), id: \.self){ theme in
                    Section(header:
                        Text(theme).roundText
                            .padding(.leading, 4)
                            .padding(.bottom, -26)
                    ) {
                        ForEach(self.items(for: theme, items: self.setsToShow ), id: \.setID) { item in
                            NavigationLink(destination: SetDetailView(set: item)) {
                                SetListCell(set:item)
                            }.padding(.leading,16).padding(.trailing,8)
                        }
                        
                        
                    }
                }
            }
            
        }
    }
    
    func sections(for items:[LegoSet]) -> [String] {
        switch sorter {
        //case .number
        case .alphabetical:
            return Array(Set(items.compactMap({String($0.name.prefix(1))}))).sorted()
        case .year:
            return Array(Set(items.compactMap({"\($0.year)"}))).sorted()
        default:
            return Array(Set(items.compactMap({$0.theme}))).sorted()
        }
    }
    func items(for section:String,items:[LegoSet]) -> [LegoSet] {
        switch sorter {

        case .alphabetical:
            return items.filter({String($0.name.prefix(1)) == section}).sorted(by: {$0.name < $1.name})
        case .year:
            return items.filter({"\($0.year)" == section}).sorted(by: {$0.name < $1.name})
        default:
            return items.filter({$0.theme == section}).sorted(by: {$0.subtheme ?? "" < $1.subtheme ?? "" && $0.name < $1.name})
        }
    }
    
    var setsToShow : [LegoSet] {
        switch filter {
        case .all:
            return  items
        case .wanted:
            return items.filter({$0.collection.wanted})
        case .owned:
            return items.filter({$0.collection.owned})
        }
    }
}
