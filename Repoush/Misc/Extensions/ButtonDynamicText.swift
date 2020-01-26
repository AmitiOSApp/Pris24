
import Foundation
import UIKit

extension UIButton {
    
    func adjustsFontSizeToFitDevice() {
        
        switch UIDevice().screenType {
        case .iPhone5:
            titleLabel?.font = titleLabel?.font.withSize((titleLabel?.font.pointSize)!)
            break
        case .iPhone6, .iPhoneX:
            titleLabel?.font = titleLabel?.font.withSize((titleLabel?.font.pointSize)! + 2)
            break
        case .iPhone6Plus:
            titleLabel?.font = titleLabel?.font.withSize((titleLabel?.font.pointSize)! + 4)
            break
        default:
            titleLabel?.font = titleLabel?.font.withSize((titleLabel?.font.pointSize)!)
        }
    }
    
}
