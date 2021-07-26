//
//  APIIssueView.swift
//  Brickie
//
//  Created by Léo on 26/07/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI

struct APIIssueView: View {
    @Binding var error : APIError?

    var body: some View {
        if error != nil {
            HStack(alignment: .center){
                Spacer()
                Text(error!.localizedDescription).multilineTextAlignment(.center).font(.footnote).foregroundColor(.orange)
                Spacer()
            }
        } else {
            EmptyView()
        }
    }
}
