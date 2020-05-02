import SwiftUI

struct  RoundedButtonStyle:  ButtonStyle {
    var backgroundColor: Color = .black
    var foregroundColor: Color = .white
    var padding : CGFloat = 16
    var radius : CGFloat = 12
    var borderColor : Color = .clear
    var borderWidth : CGFloat = 0
    
    public func makeBody(configuration: RoundedButtonStyle.Configuration) -> some View {
        
        configuration.label
            .padding(padding)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(borderColor, lineWidth: borderWidth)
        )
        
    }
}
