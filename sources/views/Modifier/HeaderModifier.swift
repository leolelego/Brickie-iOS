//
//  HeaderViewModifier.swift
//  BrickSet
//
//  Created by Work on 03/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct HeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    

    }
}



struct RoundedShadowMod : ViewModifier {
    func body(content: Content) -> some View {
        content
            
            .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.backgroundAlt.opacity(0.15), radius: 2, x: 0, y: 1)
    }
}
