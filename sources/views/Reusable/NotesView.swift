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
                 Image(systemName: "checkmark.circle").foregroundColor(.green)
            case .error:
                 Image(systemName: "xmark.circle").foregroundColor(.red)
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
                   self.status = stat ? .saved : .error
                    
                }
            }) {
                HStack(alignment: .lastTextBaseline,spacing: 8) {
                    
                    Text("notes.button").fontWeight(.bold)
                    status.view
                    
                }
                
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 24)
            }.buttonStyle(RoundedButtonStyle(backgroundColor: .cyan  )).opacity(config.connection == .unavailable || store.error == .invalid ? 0.6: 1.0)
        
    }
}
}

