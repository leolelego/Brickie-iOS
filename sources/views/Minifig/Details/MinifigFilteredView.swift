//
//  SetThemeList.swift
//  BrickSet
//
//  Created by Work on 06/06/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigFilteredView: View {
    @EnvironmentObject private var  store : Store
    var theme : String
    let filter: Store.SearchFilter
    @State var requestSent : Bool = false
    @AppStorage(Settings.figsDisplayMode) var displayMode : DisplayMode = .default

    var items : [LegoMinifig] {
        return store.minifigs.filter({
            switch filter {
            case .theme,.none,.year:
                return $0.theme == theme
            case .subtheme:
                return $0.subthemes.contains(theme)
            }
            
        })
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
                HStack{
                    Spacer()
                    Text("minifig.local").foregroundColor(.background).font(.callout).bold().multilineTextAlignment(.center)
                    Spacer()
                }
                .background(Color.backgroundAlt)
                .modifier(RoundedShadowMod())
                .padding(8)
                MinifigListView(figs: items,sorter: .constant(.default),displayMode: displayMode)
            }
        }
        .navigationBarItems(trailing:
            HStack(alignment: .center){
                if store.isLoadingData {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("\(items.filter{$0.ownedTotal > 0}.count)/\(items.count) ").font(.lego(size: 17))
                }

            }
        )
            .navigationBarTitle(theme.uppercased()+"_")
            .onAppear {
                if self.requestSent == false {
                    self.requestSent = true
                    if self.theme.lowercased().contains("series") || self.theme.lowercased().contains("minifigure"){
                        self.store.searchMinifigs(text:"Minifigure")
                    } else if self.theme.lowercased().contains("classic") {
                        self.store.searchMinifigs(text:"classic")
                        
                    } else {
                        self.store.searchMinifigs(text:self.theme)
                    }
                }
        }
    }
}


