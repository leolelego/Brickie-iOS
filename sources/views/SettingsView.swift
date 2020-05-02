//
//  SettingsView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var config = AppConfig
    
    var body: some View {
        NavigationView{
            
            VStack {
                Form {
                    Section(header: Text("Brickset Account")) {
                        HStack{
                            Text("User")
                            Spacer()
                            Text("\(AppConfig.user?.username  ?? "")")
                        }
                        
                        Button(action: {
                            API.synchronizeSets()
                                               }) {
                                                   Text( "Synchronize Sets".ls)
                                                       .fontWeight(.bold)
                                                       .frame(minWidth: 0, maxWidth: .infinity)
                                                   
                                                   }.buttonStyle(RoundedButtonStyle(backgroundColor: .blue)) .padding([.leading, .trailing], 16)
                        Button(action: {
                            self.config.user = nil
                        }) {
                            Text( "logout".ls)
                                .fontWeight(.bold)
                                .frame(minWidth: 0, maxWidth: .infinity)
                            
                            }.buttonStyle(RoundedButtonStyle(backgroundColor: .red)) .padding([.leading, .trailing], 16)
     

                    }
                    Section(header: Text("App")) {
                             Toggle(isOn: $config.uiMinifigVisible) {
                                      Text("Minifig's Section")
                                  }

                    }
                

                }
                
            }.navigationBarTitle("Settings")
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
