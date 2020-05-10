//
//  Blur.swift
//  BrickSet
//
//  Created by Work on 04/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
