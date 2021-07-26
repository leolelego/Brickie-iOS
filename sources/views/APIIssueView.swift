//
//  APIIssueView.swift
//  Brickie
//
//  Created by Léo on 26/07/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI

struct APIIssueView: View {
    @EnvironmentObject private var  store : Store

    var body: some View {
        if(store.apiHadIssue){
            HStack(alignment: .center){
                Spacer()
                Text("error.apiissue_uimessage").multilineTextAlignment(.center).font(.footnote).foregroundColor(.orange)
                Spacer()
            }
        } else {
            EmptyView()
        }
    }
}

struct APIIssueView_Previews: PreviewProvider {
    static var previews: some View {
        APIIssueView()
    }
}
