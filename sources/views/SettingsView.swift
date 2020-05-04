//
//  SettingsView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var config : Configuration
    
    var body: some View {
        NavigationView{
            
            
                Form {
                    HStack{
                        Text("\(config.user?.username  ?? "Debug Name")").font(.title)
                        Spacer()
                        Button(action: {
                            self.config.user = nil
                        }) {
                            Text( "logout".ls)
                                .fontWeight(.bold)
                            
                            
                        }.buttonStyle(RoundedButtonStyle(backgroundColor: .red, padding:8))
                    }

                    Section(header: Text("App")) {
                             Toggle(isOn: $config.uiMinifigVisible) {
                                      Text("Minifig's Section")
                                  }
                        Toggle(isOn: $config.uiMinifigVisible) {
                                                   Text("Sets Image Background")
                                               }

                    }
                

                                
            }.listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
                
                .navigationBarTitle("Settings")
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
