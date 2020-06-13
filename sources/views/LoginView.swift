//
//  LoginView.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var  collection : UserCollection
    @EnvironmentObject var config : Configuration
    @State var username = ""
    @State var password = ""
    @State var error : String?
    @State var loading = false
    
    var body: some View {
        VStack(spacing: 16){
            makeImage().offset(y: -80)
            if config.connection == .unavailable {
                Text("login.offline").font(.headline).bold().foregroundColor(.red)
            } else {
                if !loading {
                    makeFields().offset(y: -60)
                    
                }
                makeLoginButton().offset(y:-60)
            }
            
            if  error != nil && !self.loading {
                VStack{
                    Text("login.failed").font(.callout).multilineTextAlignment(.center).foregroundColor(.red).lineLimit(10)
                    
                }
            }
            //            if !loading {
            //                makeSignup()
            //            }
            makeBrickSet()
            
        }
        .frame(maxWidth: 375, alignment: .center)
        .padding([.leading, .trailing], 32)
        .modifier(DismissingKeyboardOnSwipe())
    }
    
    func makeImage() -> some View {
        VStack{
            Image("app_logo")
                .padding(20)
                            .background(Circle()
//                                .stroke(lineWidth: 3)
                                .fill(Color.white))
                .rotationEffect(Angle(degrees:loading ? 320 : 0))
                .offset(y: loading ? -600 : 0)
                .animation(Animation.interpolatingSpring(stiffness: 170, damping: 5))
            Text("Welcome to").bold()
            Text(" BRICKIE ").font(.lego(size: 32)).foregroundColor(.white)
                .padding(.top,4)
                .background(LinearGradient(gradient: Gradient(colors:[Color(red: 0/255, green: 28/255, blue: 200/255), Color(red: 89/255, green: 235/255, blue: 255/255)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
        }
        
        
    }
    
    func makeFields() -> some View {
        VStack(alignment: .leading,spacing: 8){
            //            Text("login.info").font(.subheadline).foregroundColor(.gray)//.bold()
            TextField("login.username", text: $username).textContentType(.username).autocapitalization(.none)
            Divider()
            SecureField("login.password", text: $password).textContentType(.password).transition(.move(edge: .bottom))
            Divider()
        }
    }
    
    func makeLoginButton() -> some View{
        Button(action: {
            withAnimation{
                self.loading.toggle()
            }
            APIRouter<String>.login(self.username, self.password).responseJSON { response in
                switch response {
                case .failure(let err):
                    self.error = err.localizedDescription
                    
                    break
                case .success(let hash):
                    let user = User(username: self.username, token: hash)
                    DispatchQueue.main.async {
                        self.collection.user = user
                    }
                    break
                }
                withAnimation{
                    self.loading.toggle()
                }
            }
            
        }) {
            Text(loading ? "login.buttonactive" : "login.button")
                .fontWeight(.bold).foregroundColor(.background)
                .frame(minWidth: 0, maxWidth: .infinity)
            
        }.buttonStyle(
            RoundedButtonStyle(backgroundColor:loading ? Color("purple") : (username.isEmpty || password.isEmpty) ? Color.backgroundAlt.opacity(0.1) : Color.backgroundAlt)
        ).disabled(username.isEmpty || password.isEmpty || loading)
    }
    
    
    func makeBrickSet() -> some View {
        VStack(alignment: .leading, spacing: 0){
            Text("login.powerby").bold().foregroundColor(.backgroundAlt)
            Image("brickset_logo")
        }.offset( y: 64)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().previewDevice("iPhone SE")
    }
}
