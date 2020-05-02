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
    var buttonColor : Color {
        return loading ? Color.red : (username.isEmpty || password.isEmpty) ? Color.black.opacity(0.1) : Color.black

    }
    var body: some View {
        VStack(spacing: 16){
            
            if !loading {
                TextField("Username".ls, text: $username).textContentType(.username).autocapitalization(.none)
                Divider()
                
                SecureField("Password".ls, text: $password).textContentType(.password).transition(.move(edge: .bottom))
                Divider()
            }
            Button(action: {
                withAnimation{
                    self.loading.toggle()
                }
                log("user \(self.username) - \(self.password)")
                API.login(username: self.username, password: self.password) { (result) in
                    switch result {
                    case .success():
                        log("Login Success!",.info)
                    case .failure(let err):
                        logerror(err)
                        self.error = err.localizedDescription
                    }
                    withAnimation{
                        self.loading.toggle()
                    }
                    
                }
            }) {
                Text(loading ? "Logging in ..." : "Login".ls)
                    .fontWeight(.bold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                
            }.buttonStyle(
                RoundedButtonStyle(backgroundColor:buttonColor)
            ).disabled(username.isEmpty || password.isEmpty || loading)
            
            if  error != nil {
                Text(error!).font(.callout).foregroundColor(.red).lineLimit(100)
            }
        }
        .frame(maxWidth: 375, alignment: .center)
        .padding([.leading, .trailing], 32)
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
