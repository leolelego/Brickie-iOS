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
    @EnvironmentObject var config: Configuration
    
    let credits = [
        Credit(text: "credit.brickset", link: URL(string: "https://brickset.com")!,image: Image("brickset_small")),
        Credit(text: "credit.homework", link: URL(string: "https://homework.family")!,image: Image("homework")),
    ]
    let feedbacks = [
        Credit(text: "credit.github", link: URL(string: "https://github.com/leolelego/BrickSet")!,image: Image("github")),
        Credit(text: "credit.instagram", link: URL(string: "https://instagram.com/leolelego")!,image: Image("instagram")),
        Credit(text: "credit.twitter", link: URL(string: "https://twitter.com/leolelego")!,image: Image("twitter")),
        
    ]
    
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
                
                Section(header: Text("settings.credits")) {
                    ForEach(credits){ c in
                        Button(action: {
                            UIApplication.shared.open(c.link)
                        }) {
                            HStack {
                                c.image
                                Text(c.text)
                            }
                        }
                    }
                    
                    
                    
                }
                Section(header: Text("settings.feedbacks")) {
                    ForEach(feedbacks){ c in
                        Button(action: {
                            UIApplication.shared.open(c.link)
                        }) {
                            HStack {
                                c.image
                                Text(c.text)
                            }
                        }
                    }
                }
//                if config.connection != .unavailable {
//                    Section(header: Text("settings.dangerzone")) {
//                        HStack{
//                            
//                            Text("settings.cache").font(.title)
//                            Spacer()
//                            Button(action: {
//                                self.collection.reset()
//                            }) {
//                                Text( "settings.free")
//                                    .fontWeight(.bold)
//                            }.buttonStyle(RoundedButtonStyle(backgroundColor: .red, padding:8))
//                        }
//                    }
//                }
                
                
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


struct Credit : Identifiable {
    let text : LocalizedStringKey
    let link : URL
    let image : Image
    var id : URL {
        return link
    }
}
