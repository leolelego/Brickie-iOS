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
            
            makeImage()
            
            
            
            if config.connection == .unavailable {
                Text("login.offline").font(.headline).bold().foregroundColor(.red)
            } else {
                if !loading {
                    makeFields().offset(y: -30)
                    
                }
                makeLoginButton().offset(y:-30)
            }
            
            if  error != nil && !self.loading {
                VStack{
                    Text(error!).font(.callout).foregroundColor(.red)
                    
                }
            }
            if !loading {
                makeSignup()
            }
            makeBrickSet()
            
        }
        .frame(maxWidth: 375, alignment: .center)
        .padding([.leading, .trailing], 32)
        .modifier(DismissingKeyboardOnSwipe())
    }
    
    func makeImage() -> some View {
        Image("app_logo")
            .padding(20)
            .overlay(Circle()
                .stroke(lineWidth: 3)
                .stroke(Color.backgroundAlt))
            .rotationEffect(Angle(degrees:loading ? 30 : 320))
            .offset(y: loading ? -600 : -30)
            .animation(Animation.interpolatingSpring(stiffness: 170, damping: 5))
    }
    
    func makeFields() -> some View {
        VStack{
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
    
    func makeSignup() -> some View{
        Button(action: {
                        if let url = URL(string: "https://brickset.com/signup") {
                            UIApplication.shared.open(url)
                        }
        }) {
            VStack(alignment: .center, spacing: 0){
                Text("login.donthaveaccount")
                    .bold()
                Text("login.signup").font(.title)
                    .bold()
                    .foregroundColor(.blue)
            }
        }
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
