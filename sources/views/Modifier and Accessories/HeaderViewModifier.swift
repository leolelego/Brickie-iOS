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
            .padding(8)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity,alignment:.leading)
                    .background(Color.black)
            .cornerRadius(12, antialiased: true)
    }
}


