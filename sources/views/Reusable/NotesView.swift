//
//  NotesView.swift
//  Brickie
//
//  Created by Léo on 25/01/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    enum NotesViewStatus {
        case none
        case saving
        case saved
        case error
        
        @ViewBuilder var view : some View {
            switch self {
            case .none:
                EmptyView()
            case .saving:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            case .saved:
                Image(systemName: "hand.thumbsup.circle.fill").foregroundColor(.white)
            case .error:
                Image(systemName: "hand.thumbsdown.circle.fill").foregroundColor(.white)
            }
        }
        var color : Color {
            switch self {
            case .none:return .mint
            case .saving:return .blue
            case .saved:return .green
            case .error: return .orange
                
            }
        }
    }
    @EnvironmentObject var store : Store
    @EnvironmentObject var config : Configuration
    
    @Binding var note :String
    @State var status  = NotesViewStatus.none
    let onSave :  (@escaping (Bool)->Void) -> Void
    
    var body: some View {
        VStack{
            TextView(text:$note).frame(minHeight: 100)
            Spacer(minLength: 8)
            Button(action: {
                onSave(){ stat in
                    withAnimation {
                        self.status = stat ? .saved : .error
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            status =  status == .saved ? .none : status
                        }
                    }
                    
                }
            }) {
                ZStack(alignment: .trailing) {
                    HStack{
                        Spacer()
                        Text("notes.button")
                            .fontWeight(.bold).foregroundColor(Color.black)
                        Spacer()
                        
                    }
                    status.view
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 24)
            }.buttonStyle(RoundedButtonStyle(backgroundColor: status.color  )).opacity(config.connection == .unavailable || store.error == .invalid ? 0.6: 1.0)
            
        }
    }
}

