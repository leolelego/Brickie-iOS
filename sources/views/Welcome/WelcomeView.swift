//
//  WelcomeView.swift
//  Brickie
//
//  Created by Léo on 07/02/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import SwiftUI
// MARK: - API
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    public func foreground<Overlay: View>(_ overlay: Overlay) -> some View {
        self.overlay(overlay).mask(self)
    }
}
struct WelcomeView: View {
    @SceneStorage(Settings.displayWelcome)  var displayWelcome : Bool = true

    @State var more = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading,spacing: 16){
                VStack(alignment: .leading, spacing: -8) {
                    Text("wlcm.header").bold().font(.system(size: 48, weight: .heavy, design: .default))

                    Text("Brickie").bold().font(.system(size: 40, weight: .heavy, design: .default))
                        .foreground(LinearGradient(
                        gradient: Gradient(colors:[Color(red: 0/255, green: 28/255, blue: 200/255), Color(red: 89/255, green: 170/255, blue: 255/255)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                }
                
                
                Text("wlcm.subheader").font(.body)
               
                Spacer(minLength: 24)
                VStack(alignment: .leading, spacing: 32) {
                    ForEach(WelcomeEnum.allCases,id:\.self){ i in
                        WelcomeItemView(value: i)
                    }
                }.padding(.horizontal)
                Spacer()
                
            }.padding()
            if more {
                Text("wlcm.more").font(.system(.callout, design: .monospaced))
                    
                    .foregroundColor(.secondary).padding()
            } else {
                Button("wlcm.morebtn"){
                    withAnimation {
                        more = true
                    }
                }.font(.callout)
            }
            
            Button(action: {
                displayWelcome = false
            }, label: {
                Text("wlcm.btn").bold()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20)
            })
                .buttonStyle(RoundedButtonStyle(backgroundColor:.blue))
                .padding(.horizontal)
            Text("wlcm.needbrickset").font(.footnote).foregroundColor(.secondary).padding(32)
            
            Spacer()
            
        }.padding(.horizontal)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView().previewDevice("iPhone SE")
        }
    }
}
