//
//  File.swift
//  BrickSet
//
//  Created by Work on 10/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import Alamofire
struct LegoPDFView : View {
    let stringURL : String?
    var url : URL? {
        return stringURL == nil ? nil : URL(string: stringURL!)
    }
    @State var localURL : URL? = nil
    @State var progress : Double = 0
    var body: some View {
        Group {
            if stringURL == nil {
                Text("instruction.errorfile")
            } else if localURL == nil {
                Text("instruction.downloading ") + Text("\(Int(progress * 100))%")
            } else {
                PDFKitView(url: localURL!)
            }
        }.onAppear {
            self.download()
        }
        .navigationBarTitle("instruction.title",displayMode: .large)
        
    }
    
    func download(){
        guard let u = self.url else {return}
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(u.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: fileURL.absoluteString){
            localURL = fileURL
        } else {
            
            
            let destination: DownloadRequest.Destination = { _, _ in
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            AF.download(u, to: destination)
                .downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: { (progress) in
                    self.progress = progress.fractionCompleted
                })
                .response { res in
                    if res.error == nil {
                        self.localURL = res.fileURL
                    }
                    logerror(res.error)
                    
            }
        }
        
    }
    
}

