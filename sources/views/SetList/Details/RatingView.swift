//
//  RatingView.swift
//  Brickie
//
//  Created by Léo on 05/01/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import SwiftUI
enum RatingStar :  String {
    case filled =  "star.fill"
    case half = "star.leadinghalf.fill"
    case empty = "star"
    
    var view : some View {
        Image(systemName: self.rawValue)
    }
}
struct RatingView: View {
    let rating : Float
    var floatingStar : some View {
        let f = self.rating.truncatingRemainder(dividingBy: 1)
        if f > 0.8 {
            return RatingStar.filled.view
        } else if f < 0.3 {
            return RatingStar.empty.view
        } else {
            return RatingStar.half.view
        }
        
    }

    var filledStar : Int {
        let f = floor(rating)
        let i = Int(f)
        return i
    }
    var emptyStar : Int {5-filledStar-1}
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            HStack {
            if filledStar > 0 {
                ForEach(1...filledStar, id: \.self){ _ in
                    RatingStar.filled.view
                }
            }
            floatingStar
            if emptyStar > 0 {
                ForEach(1...emptyStar, id: \.self){ _ in
                    RatingStar.empty.view
                }
            }
            }.modifier(Rainbow())
            Text("(\(String(format: "%.1f", rating)))").bold()
        }
    }
}
extension Float {
    func truncate(places : Int)-> Float {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
}
struct Rainbow: ViewModifier {
    let hueColors = [
        Color(red: 255/255, green: 102/255, blue: 102/255),
        Color(red: 255/255, green: 189/255, blue: 85/255),
        Color(red: 255/255, green: 255/255, blue: 102/255),
        Color(red: 157/255, green: 226/255, blue: 79/255),
        Color(red: 135/255, green: 206/255, blue: 250/255),
    ]

    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { (proxy: GeometryProxy) in
                ZStack {
                    LinearGradient(gradient: Gradient(colors: self.hueColors),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .frame(width: proxy.size.width)
                }
            })
            .mask(content)
    }
}
