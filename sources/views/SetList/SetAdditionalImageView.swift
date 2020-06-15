//
//  SetAdditionalImageView.swift
//  BrickSet
//
//  Created by Work on 23/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct SetAdditionalImageView: View {
    @Binding var isPresented : Bool
    let url : String
    @State var lastScale: CGFloat = 1.0
    @State var scale: CGFloat = 1.0
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    var body: some View {
        let scaleGesture = MagnificationGesture(minimumScaleDelta: 0.1).onChanged { value in
            let delta = value / self.lastScale
            self.lastScale = value
            let newScale = self.scale * delta
            self.scale = min(max(newScale, 1), 6)
        }.onEnded { value in
            self.lastScale = 1.0
        }
        let dragGesture =
            DragGesture()
                .onChanged { value in
                    if self.scale  > 1 {
                        self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    }
                    
            }
            .onEnded { value in
                if self.scale  > 1 {
                    
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    self.newPosition = self.currentPosition
                }
        }
        
        let dragBeforePinch = dragGesture.exclusively(before: scaleGesture)
        return VStack {
            Spacer()
            makeIt()
                .scaleEffect(self.scale)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                
                .gesture(dragBeforePinch)
            Spacer()
            
            
        }
        .onTapGesture {
            self.lastScale = 1.0
            self.scale = 1.0
            self.currentPosition = .zero
            self.newPosition = .zero
        }
            
            
        .edgesIgnoringSafeArea(.all)
    }
    
    func makeIt()-> some View {
        WebImage(url: URL(string: url), options: [.progressiveLoad, .delayPlaceholder])
            .resizable()
            .placeholder(Image.wifiError.resizable())
            .renderingMode(.original)
            .indicator(.progress)
            .scaledToFit()
    }
}


