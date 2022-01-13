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
            .foregroundColor(.backgroundAlt)
    }
}

