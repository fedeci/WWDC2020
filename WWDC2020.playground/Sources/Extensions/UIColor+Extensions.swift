import UIKit

extension UIColor {
    
    static let main = UIColor(hex: 0xFF9100)
    static let gray = UIColor(hex: 0x707070)
    static let lightGray = UIColor(hex: 0xF0F0F0)
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
        self.init(red: CGFloat((hex >> 16) & 0xff), green: CGFloat((hex >> 8) & 0xff), blue: CGFloat(hex & 0xff))
    }
}
