//
//  SettingsView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var  collection : UserCollection
    @Environment(\.config) var config: Configuration

    var body: some View {
        NavigationView{
            
            
                Form {
                    HStack{
                        Text("\(collection.user?.username  ?? "Debug Name")").font(.title)
                        Spacer()
                        Button(action: {
                            self.collection.user = nil
                        }) {
                            Text( "settings.logout")
                                .fontWeight(.bold)
                            
                            
                        }.buttonStyle(RoundedButtonStyle(backgroundColor: .red, padding:8))
                    }
                    
                    if config.isDebug {
                        HStack{
                            Text("User Hash").font(.title)
                            Spacer()
                            Button(action: {
                                let pasteboard = UIPasteboard.general
                                pasteboard.string = self.collection.user?.token ?? ""
                            }) {
                                Text(collection.user?.token ?? "")
                                    .fontWeight(.bold)
                                
                                
                            }.buttonStyle(RoundedButtonStyle(backgroundColor: .red, padding:8))
                        }
                        
                    }
//
//                    Section(header: Text("settings.credit")) {
//                      
//
//                    }
                

                                
            }.listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
                
                .navigationBarTitle("settings.title")
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
