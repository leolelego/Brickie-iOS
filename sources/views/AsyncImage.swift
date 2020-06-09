//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Vadym Bulavin on 2/13/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct AsyncImage : View {

    let url : URL?
    
    public init(path: String?) {
         self.url = URL(string: path ?? "")
     }
    
    var body: some View {
        
        WebImage(url: url)
                .resizable()
                .renderingMode(.original)
                .indicator(.activity)
                .transition(.fade)
                .aspectRatio(contentMode: .fit)

    }

}
