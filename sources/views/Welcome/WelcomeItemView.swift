//
//  WelcomeItemView.swift
//  Brickie
//
//  Created by Léo on 09/02/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import SwiftUI

struct WelcomeItemView : View {
    let value : WelcomeEnum
    var body : some View {
        HStack(alignment: .top,spacing: 16){
            value.image
            VStack(alignment: .leading, spacing: 4){
                Text(value.title)
                    .bold().multilineTextAlignment(.leading)
                Text(value.content).font(.callout)
                    .foregroundColor(.secondary).multilineTextAlignment(.leading)
            }
        }
    }
}
// Here but should not be here
enum WelcomeEnum : String,CaseIterable {
    case setsAndFigs
//    case minifigures
    case notes
    case afol
    case opensource
    
    var image : Image {
        switch self {
        default: return Image("app_logo")
        }
    }
    var title : LocalizedStringKey  { LocalizedStringKey("wlcm."+self.rawValue+".title")}
     var content : LocalizedStringKey  { LocalizedStringKey("wlcm."+self.rawValue+".content")}

}
