//
//  SettingsView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI


struct SettingsView: View {

    @EnvironmentObject private var  store : Store
    @Environment(\.presentationMode) var presentationMode
//    @AppStorage(Settings.currency) var currency : Currency = .default

    let feedbacks = [
        Credit(text: "credit.email", link: URL(string:kFeedbackMailto)!,image: Image(systemName:"envelope.fill")),
        Credit(text: "credit.github", link: URL(string: "https://github.com/leolelego/BrickSet")!,image: Image("github")),
        //Credit(text: "credit.instagram", link: URL(string: "https://instagram.com/leolelego")!,image: Image("instagram")),
        Credit(text: "credit.twitter", link: URL(string: "https://twitter.com/leolelego")!,image: Image("twitter"))
    ]
    
    @State var logout = false
    
    var body: some View {
        NavigationView{
            Form {
                Section(header:makeThanks()){
                    
                    HStack{
                        Text("\(store.user?.username  ?? "Debug Name")").font(.title)
                        Spacer()
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            self.logout = true
                        }) {
                            Text( "settings.logout")
                                .fontWeight(.bold)
                            
                            
                        }.buttonStyle(RoundedButtonStyle(backgroundColor: .red, padding:8))
                    }
                    
                    
                    if isDebug {
                        HStack{
                            Text("User Hash").font(.title)
                            Spacer()
                            Button(action: {
                                let pasteboard = UIPasteboard.general
                                pasteboard.string = self.store.user?.token ?? ""
                            }) {
                                Text(store.user?.token ?? "")
                                    .fontWeight(.bold)
                            }.buttonStyle(RoundedButtonStyle(backgroundColor: .red, padding:8))
                        }
                        
                        
                    }
                    
                    HStack{
                        Text("settings.collection")
                        Spacer()
                        Text(String(store.sets.qtyOwned)+" ").font(.lego(size: 20))
                        Image.brick
                        Text(String(store.minifigs.qtyOwned)+" ").font(.lego(size: 20))
                        Image.minifig_head
                    }
                    HStack{
                        Text("settings.pricecollection")
                        Spacer()
                        Text(currencyFormatter.string(for:store.sets.priceOwned) ?? "")
                    }
                }
                
                
                Section(header: Text("settings.feedbacks"),footer: makeFooter()) {
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
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            })
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("settings.title")
        }
        .onDisappear {
            if self.logout {
                
                self.store.user = nil
                self.store.reset()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.backgroundAlt)
        
    }
    
    func makeThanks()-> some View{
        VStack{
            HStack{
                Spacer()
                VStack{
                    Image("app_logo")
                        .padding(20)
                        .background(Circle()
                            .fill(Color.white))
                    Text("credit.thanks").bold()
                    Text(" BRICKIE ").font(.lego(size: 32)).foregroundColor(.white)
                        .padding(.top,4)
                        .background(LinearGradient(gradient: Gradient(colors:[Color(red: 0/255, green: 28/255, blue: 200/255), Color(red: 89/255, green: 235/255, blue: 255/255)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    func makeFooter() -> some View {
        VStack(alignment: .leading, spacing: 16, content: {
            makeBrickSet()
            makeAppVersion()
        
        })
    }
    func makeBrickSet() -> some View {
        HStack(alignment: .center, spacing: 8){
            Text("login.powerby").bold().foregroundColor(.backgroundAlt)
            Image("brickset_logo")
        }
        
    }
    func makeAppVersion() -> some View {
        HStack(alignment: .center, spacing: 8){
            Spacer()
            Text("v\(kAppversion) (\(kAppBuild))").font(.footnote)
            Spacer()

        }
        
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
