//
//  PDFKitView.swift
//  BrickSet
//
//  Created by Work on 10/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFKitView : UIViewRepresentable {
    
    var document: PDFDocument?
    let pdfView = PDFView()

    func makeUIView(context: Context) -> UIView {
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous

        pdfView.document = document

        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Empty
    }
    
}
