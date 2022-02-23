import SpriteKit
import Foundation
import CoreGraphics


extension SKNode {
    
    func aspectScale(to size:CGSize, width: Bool, multiplier: CGFloat){
        let scale = width ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
}

struct ZPosition {
    static let background: CGFloat = 0
    static let obstacles: CGFloat = 1
    static let hudBackground: CGFloat = 10
    static let bird: CGFloat = 2
    static let hudLabel: CGFloat = 11
}
