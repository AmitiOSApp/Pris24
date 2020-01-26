
import Foundation
import UIKit

extension UILabel {
    
    func adjustsFontSizeToFitDevice() {
        
        switch UIDevice().screenType {
        case .iPhone5:
            font = font.withSize(font.pointSize)
            break
        case .iPhone6, .iPhoneX:
            font = font.withSize(font.pointSize + 2)
            break
        case .iPhone6Plus:
            font = font.withSize(font.pointSize + 4)
            break
        default:
            font = font.withSize(font.pointSize)
        }
    }
    
}
