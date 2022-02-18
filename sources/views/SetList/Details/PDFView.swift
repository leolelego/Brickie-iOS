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
    @State private var loader: DataLoader
    @State var data : Data?
    init(string:String,cache:DataCache){
        loader = DataLoader(url: URL(string: string), cache: cache)
    }

    var body: some View {
        Group {
            if data != nil {
                PDFKitView(document: PDFDocument(data:data!))
            } else {
                VStack {
                    Text("instruction.downloading").padding()
                    if loader.dataTask != nil{
                        ProgressView(loader.dataTask!.progress).progressViewStyle(.linear).padding(.horizontal, 32)
                    }
                }
        }
        }.onAppear {
            self.loader.syncLoad { data in
                self.data = data
            }
        }.onDisappear{
            self.loader.cancel()
        }
        .navigationBarTitle("instruction.title",displayMode: .inline)

    }

    
}

