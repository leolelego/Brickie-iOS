import Foundation

extension CharacterSet {
    static var plus: CharacterSet {
        CharacterSet(charactersIn: "/+").inverted
    }
}
