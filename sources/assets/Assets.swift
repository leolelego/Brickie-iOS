//
//  Colors.swift
//  BrickSet
//
//  Created by Work on 03/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//
import SwiftUI
extension Color {
    public static var background: Color {
        Color("background", bundle: nil)
    }
    public static var backgroundAlt: Color {
        Color("backgroundAlt", bundle: nil)
    }
    public static var purple: Color {
        Color("purple", bundle: nil)
    }
}

extension Image {
  
    static var minifig_head: Image { Image("lego_head") }
    static var brick: Image { Image("lego_brick") }
    static var wifiError : Image {Image(systemName:"wifi.slash")}
    public static func minifig_head(height:CGFloat) -> some View {
        Image("lego_head").resizable().frame(width: height*35.0/41.0, height: height)  // 35 × 41 pixels
    }
    public static func brick(height:CGFloat) -> some View {
        Image("lego_brick").resizable().frame(width: height*47.0/43.0, height: height)  // 35 × 41 pixels
    }
    
    

}

extension Font {
    static func lego(size:CGFloat)->Font{
        Font.custom("LEGothicType", size: size)
    }
}
