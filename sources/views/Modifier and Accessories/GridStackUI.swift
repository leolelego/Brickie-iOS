//
//  GridStackUI.swift
//  Vingt-Huit
//
//  Created by Work on 10/04/2020.
//  Copyright © 2020 WISIMAGE. All rights reserved.
//

import SwiftUI
struct GridStack<Content: View,DataType>: View {
    let rows: Int
    let columns: Int
    let data : [DataType]
    let content: (DataType) -> Content
    let verticalSpacing : CGFloat = 8
    let horizontalSpacing : CGFloat = 8
    let horizontalAlignement : HorizontalAlignment = .leading
    let verticalAlignement : VerticalAlignment = .top
    
    var body: some View {
//        GeometryReader { geo in

            VStack(alignment: self.horizontalAlignement, spacing: self.verticalSpacing) {
                ForEach(0 ..< self.rows, id: \.self) { row in
                    
                    HStack(alignment: self.verticalAlignement, spacing: row != self.rows-1 ? self.horizontalSpacing : 0) {

                        ForEach(0 ..< self.columns, id: \.self) { column in
                            self.cell(col: column, row: row)//.frame(width:self.frameWidth(geo))
                        }//.frame(height:800)
                    }
                    
                }
            }
//        }
    }
    
    func frameWidth(_ geo:GeometryProxy) -> CGFloat {
        let column =  CGFloat(columns)
        let splitWith = geo.size.width / column
        let margin = verticalSpacing*(column-1)
        return  splitWith - margin
    }
    
    init(data:[DataType], rows: Int = 0, columns: Int = 0, @ViewBuilder content: @escaping (DataType) -> Content) {
        self.data = data
        self.columns = columns == 0 ?  data.count / rows + 1 : columns
        self.rows = rows == 0 ?  data.count / columns + 1 : rows
        self.content = content
    }
    
    func cell(col:Int,row:Int) -> AnyView {
        let idx = self.columns * row + col
        if idx < self.data.count {
            let item =  data[idx]
            return AnyView(content(item))
        }
        return AnyView(Text(""))
    }
}

struct GridStack_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            GridStack(data: [0,1,2,3,4], columns: 2) { item in
                VStack(spacing: 20){
                    Text("cat.capitalized")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, maxHeight: 5, alignment: .topLeading)
                        .font(Font.system(size: 13))
                        .multilineTextAlignment(.leading).padding(.top, -5)
                    
                    Text("+")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, maxHeight: 10, alignment: .center)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                    
                    
                    Text("Tapez pour modifier")
                        .frame(width: 134, height: 5, alignment: .bottom)
                        .foregroundColor(Color.gray)
                        .font(Font.system(size: 9))
                }
                .padding(10)
                    //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 90, maxHeight: 90, alignment: .top)
                    .background(Color("cellColor"))
                    .cornerRadius(10)
            }
            .padding(8)
        }.background(Color.red)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
    }
}
