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
    public static var backgroundContrast: Color {
        Color("backgroundContrast", bundle: nil)
    }
    public static var textLight: Color {
        Color("textLight", bundle: nil)
    }
    public static var backgroundAlt: Color {
        Color("backgroundAlt", bundle: nil)
    }
    public static var purple: Color {
        Color("purple", bundle: nil)
    }
    
    public static var legoGreen : Color {
        Color(red: 165/255, green: 202/255, blue: 25/255)
    }
    public static var legoOrange : Color {
        Color( red: 214/255, green: 121/255, blue: 35/255) //214, 121, 35
    }
    
    public static var legoYellow : Color {
        Color( red: 250/255, green: 200/255, blue: 10/255) //250, 200, 10
    }
    public static var legoRed : Color {
        Color( red: 180/255, green: 0/255, blue: 0/255)
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
    static func number(size:CGFloat)->Font{
        return Font.custom("RoundedMplus1c-Black", size: size)
    }
}
