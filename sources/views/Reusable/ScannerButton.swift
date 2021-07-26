//
//  ScannerButton.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct ScannerButton: View {
    @EnvironmentObject private var  store : Store
    @State private var isShowingSheet = false
    
    @Binding var code : String
    var body: some View {
        if store.error == nil {
            Button(action: {
                self.isShowingSheet.toggle()
            }, label: {
                Image(systemName: "barcode.viewfinder")
            }).sheet(isPresented: $isShowingSheet) {
                CodeScannerView(codeTypes: [.ean8, .ean13, .pdf417], completion: self.handleScan)
            }
        } else {
            EmptyView()
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingSheet = false
        switch result {
        case .success(let code):
            self.code = code
        case .failure(let error):
            logerror(error)
        }
    }
}
