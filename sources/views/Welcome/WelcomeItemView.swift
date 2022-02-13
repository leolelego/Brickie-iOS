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
            
            LinearGradient.blueBlue
                        .mask(value.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                              )
            
                        .frame(width: 50, height: 50, alignment: .center)
            
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
        case .notes : return Image(systemName: "pencil.tip.crop.circle")
        case .afol : return Image(systemName: "person.crop.circle")
        case .opensource : return Image("github")
        default: return Image("app_logo")
        }
    }
    var title : LocalizedStringKey  { LocalizedStringKey("wlcm."+self.rawValue+".title")}
     var content : LocalizedStringKey  { LocalizedStringKey("wlcm."+self.rawValue+".content")}

}

struct WelcomeItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeItemView(value: .setsAndFigs)
                .previewLayout(PreviewLayout.sizeThatFits)
                       .padding()
                       .previewDisplayName("Default preview")
            WelcomeItemView(value: .notes)
                .previewLayout(PreviewLayout.sizeThatFits)
                       .padding()
                       .previewDisplayName("Default preview")
            WelcomeItemView(value: .afol)
                .previewLayout(PreviewLayout.sizeThatFits)
                       .padding()
                       .previewDisplayName("Default preview")
            WelcomeItemView(value: .opensource)
                .previewLayout(PreviewLayout.sizeThatFits)
                       .padding()
                       .previewDisplayName("Default preview")
        }
    }
}
