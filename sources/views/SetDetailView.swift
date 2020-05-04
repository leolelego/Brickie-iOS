//
//  SetDetailView.swift
//  BrickSet
//
//  Created by Work on 03/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct SetDetailView: View {
    @State var set : LegoSet
    var body: some View {
        Text(set.name)
    }
}
struct SetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        SetDetailView(set:previewCollection.setsOwned.first!)
    }
}
