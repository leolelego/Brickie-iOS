//
//  LoginView.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var username = ""
    @State var password = ""
    @State var error : String?
    @State var loading = false

    var body: some View {
        VStack(spacing: 16){
            
            makeImage()
            
            
            if !loading {
                makeFields().offset(y: -30)

            }
            makeLoginButton().offset(y:-30)

            
            if  error != nil {
                Text(error!).font(.callout).foregroundColor(.red).lineLimit(100)
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
        Image.minifig_head(height: 80)
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
            API.login(username: self.username, password: self.password) { (result) in
                switch result {
                case .success():break
                case .failure(let err):
                    self.error = err.localizedDescription
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
            if let url = URL(string: API.signupLink) {
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
