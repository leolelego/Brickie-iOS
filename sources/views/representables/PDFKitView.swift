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
    
    var url: URL?
    
    func makeUIView(context: Context) -> UIView {
        let pdfView = PDFView()

        if let url = url {
            pdfView.document = PDFDocument(url: url)
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Empty
    }
    
}
