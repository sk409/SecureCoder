import UIKit

class CodeLabel: UILabel {
    
    enum PositionX {
        case left
        case right
        case center
    }
    
    enum PositionY {
        case top
        case bottom
        case center
    }
    
    var positionX = PositionX.left
    var positionY = PositionY.bottom
    
}
