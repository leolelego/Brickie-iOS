//
//  TextView.swift
//  Brickie
//
//  Created by Léo on 12/01/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import SwiftUI
import Combine
struct TextView: View {
    @Binding var text : String
    var body: some View {
        ZStack(alignment: .topLeading) {
              Text(text.isEmpty ? "notes.placeholder" : text)
                  .lineSpacing(6)
                  .opacity(text.isEmpty ? 0.75 : 0)
                  .padding(.all, 8)
                  .frame(maxWidth: .infinity, alignment: .leading)
                
              TextEditor(text: $text).lineSpacing(6)
          
        }.padding(4)
            .background(Color.backgroundContrast)
            .cornerRadius(6)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            UITextView.appearance().isScrollEnabled  = false // here
        }
    }
}

