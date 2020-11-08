//
//  File.swift
//  BrickSet
//
//  Created by Work on 10/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import PDFKit

struct LegoPDFView : View {
    @ObservedObject private var loader: DataLoader
    let stringURL : String
    init(string:String,cache:DataCache){
        stringURL = string
        loader = DataLoader(url: URL(string: string), cache: cache)
    }

    var body: some View {
        Group {
            if loader.data != nil {
                PDFKitView(document: PDFDocument(data:loader.data!))
            } else {
                VStack {
                    Text("instruction.downloading")
                }
            }
        }.onAppear {
            self.loader.load()
        }.onDisappear{
            self.loader.cancel()
        }
        .navigationBarTitle("instruction.title",displayMode: .inline)
//        .navigationBarItems(trailing: ShareNavButton(items: [URL(string:stringURL)!]))

    }

    
}

