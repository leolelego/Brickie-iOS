//
//  File.swift
//  BrickSet
//
//  Created by Work on 10/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import PDFKit

struct InstructionsView : View {
    @Environment(\.dataCache) var cache: DataCache

    @State var currentIndex : Int = 0
    let values : [LegoSet.Instruction]
    var body : some View {
        TabView (selection:$currentIndex){
            ForEach(0..<values.count, id: \.self){ i in
                LegoPDFView(instruction: values[i], cache: cache)
            }
        }.tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
struct LegoPDFView : View {
    @ObservedObject private var loader: DataLoader
    let value : LegoSet.Instruction
    init(instruction:LegoSet.Instruction,cache:DataCache){
        value = instruction
        loader = DataLoader(url: URL(string: value.URL), cache: cache)
    }

    var body: some View {
        Group {
            if let data = loader.data, let t = loader.dataTask, t.progress.isFinished  {
                PDFKitView(document: PDFDocument(data:data))
            } else {
                VStack {
                    Text("instruction.downloading").padding()
                    Text(value.description).bold().padding()
                    if loader.dataTask != nil{
                        ProgressView(loader.dataTask!.progress)
                            .progressViewStyle(.linear).padding(.horizontal, 32)
                    }
                }
            }
        }
        .navigationBarTitle("instruction.title",displayMode: .inline)
        .onAppear {
            self.loader.load()
        }.onDisappear{
            self.loader.cancel()
        }

    }

    
}

