//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Vadym Bulavin on 2/13/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import SwiftUI

struct AsyncImage : View {
    @ObservedObject private var loader: DataLoader
    private let configuration: (Image) -> Image
    
    init(string: String?, cache: DataCache? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
        loader = DataLoader(url: URL(string:string ?? ""), cache: cache)
           self.configuration = configuration
       }
    init(url: URL?, cache: DataCache? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
        loader = DataLoader(url: url, cache: cache)
        self.configuration = configuration
    }
    
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    var uiImage : UIImage {
        guard let data = loader.data,
            let image = UIImage(data:data)
            else {
                return UIImage()
        }
        return image
    }
    private var image: some View {
        Group {
            if loader.data != nil {
                configuration(Image(uiImage:uiImage))
            } else {
                Rectangle().fill(Color.gray)//.background(Color.gray)
            }
        }
    }
}
