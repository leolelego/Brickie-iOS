//
//  Colors.swift
//  BrickSet
//
//  Created by Work on 03/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//
import SwiftUI
extension Color {
    public static var appBlack: Color {
        Color("header", bundle: nil)
    }
    public static var background: Color {
        Color("background", bundle: nil)
    }
    public static var header: Color {
        Color("header", bundle: nil)
    }
    public static var cellBackground: Color {
        Color("cell", bundle: nil)
    }

    public static var title: Color {
        Color("header", bundle: nil)
    }
    public static var text: Color {
        Color("header", bundle: nil)
    }
    public static var textAlternate: Color {
        Color("background", bundle: nil)
    }
    
    public static var purple: Color {
        Color("purple", bundle: nil)
    }
}

extension Image {
    public static var tab_minifig: Image {
        Image("tab_minifig")
    }
    public static var tab_sets: Image {
        Image("tab_sets")
    }
    public static var cell_minifig: Image {
        Image("tab_minifig")
    }
    public static var cell_sets: Image {
        Image("tab_sets")
    }
}
