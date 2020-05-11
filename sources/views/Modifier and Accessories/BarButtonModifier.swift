//
//  BarButtonModifier.swift
//  BrickSet
//
//  Created by Work on 11/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct BarButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .imageScale(.large)
            .foregroundColor(.background)
            .background(Circle()
                .fill(Color.backgroundAlt)
                .frame(width:38,height: 38)
        )
    }
}

struct ShareNavButton : View{
    let items : [String]
    @State private var showingSheet = false
    
    var body: some View {
        Button(action: {
            self.showingSheet.toggle()
        }) {
            Image(systemName: "square.and.arrow.up").modifier(BarButtonModifier())
        }
        .sheet(isPresented: $showingSheet) {
            AnyView(ActivityControllerView(activityItems: self.items,applicationActivities: nil))
        }
    }
}


struct RotateAnimation: ViewModifier {
    @State var animate : Bool = false
    @State var animate1 : Bool = false
    @State var animate2 : Bool = false
    @State var animate3 : Bool = false
    @State var animate4 : Bool = false

    func body(content: Content) -> some View {
        HStack {
            content.foregroundColor(.red)
                .offset(y: animate ? 0 : 15)
                .animation(Animation.interpolatingSpring(stiffness: 170, damping: 5)
                    .repeatForever(autoreverses: false)
            )
                .onAppear() {
                    self.animate.toggle()
            }
            content.foregroundColor(.yellow)
                .offset(y: animate1 ? 0 : 15)
                .animation(Animation.interpolatingSpring(stiffness: 170, damping: 5)
                    .repeatForever(autoreverses: false)
                    .delay(0.1)
            )
                .onAppear() {
                    self.animate1.toggle()
            }
            content.foregroundColor(.blue)
                .offset(y: animate2 ? 0 : 15)
                .animation(Animation.interpolatingSpring(stiffness: 170, damping: 5)
                    .repeatForever(autoreverses: false)
                    .delay(0.2)

            )
                .onAppear() {
                    self.animate2.toggle()
            }
            content.foregroundColor(.purple)
                .offset(y: animate3 ? 0 : 15)
                .animation(Animation.interpolatingSpring(stiffness: 170, damping: 5)
                    .repeatForever(autoreverses: false)
                    .delay(0.3)

            )
                .onAppear() {
                    self.animate3.toggle()
            }
            content.foregroundColor(.green)
                .offset(y: animate4 ? 0 : 15)
                .animation(Animation.interpolatingSpring(stiffness: 170, damping: 5)
                    .repeatForever(autoreverses: false)
                    .delay(0.4)

            )
                .onAppear() {
                    self.animate4.toggle()
            }
  
        }
        
    }
}
