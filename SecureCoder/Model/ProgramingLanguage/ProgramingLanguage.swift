import UIKit

enum ProgramingLanguage: String {
    
    case html
    case css
    case javaScript
    case php
    
    init(extension: Extension) {
        switch `extension` {
        case .html:
            self = .html
        case .css:
            self = .css
        case .js:
            self = .javaScript
        case .php:
            self = .php
        }
    }
    
    var themeColor: UIColor {
        switch self {
        case .html:
            return UIColor(red: 147 / 255, green: 239 / 255, blue: 236 / 255, alpha: 1)
        case .css:
            return UIColor(red: 147 / 255, green: 239 / 255, blue: 236 / 255, alpha: 1)
        case .javaScript:
            return UIColor(red: 172 / 255, green: 208 / 255, blue: 255 / 255, alpha: 1)
        case .php:
            return UIColor(red: 226 / 255, green: 207 / 255, blue: 255 / 255, alpha: 1)
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .html:
            return UIColor(red: 97 / 255, green: 183 / 255, blue: 180 / 255, alpha: 1)
        case .css:
            return UIColor(red: 97 / 255, green: 183 / 255, blue: 180 / 255, alpha: 1)
        case .javaScript:
            return UIColor(red: 139 / 255, green: 184 / 255, blue: 247 / 255, alpha: 1)
        case .php:
            return UIColor(red: 170 / 255, green: 156 / 255, blue: 216 / 255, alpha: 1)
        }
    }
    
    var title: String {
        switch self {
        case .html:
            return "HTML&CSS"
        case .css:
            return "CSS"
        case .javaScript:
            return "JavaScript"
        case .php:
            return "PHP"
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .html:
            return UIImage(named: "html-logo")!
        case .css:
            return UIImage(named: "css-logo")!
        case .javaScript:
            return UIImage(named: "js-logo")!
        case .php:
            return UIImage(named: "php-logo")!
        }
    }
    
    var checkMarkIconImage: UIImage {
        switch self {
        case .html:
            return UIImage(named: "html-check-icon")!
        case .css:
            return UIImage(named: "html-check-icon")!
        case .javaScript:
            return UIImage(named: "js-check-icon")!
        case .php:
            return UIImage(named: "php-check-icon")!
        }
    }
    
    var bubbleImage: UIImage {
        switch self {
        case .html:
            return UIImage(named: "html-bubble")!
        case .css:
            return UIImage(named: "html-bubble")!
        case .javaScript:
            return UIImage(named: "js-bubble")!
        case .php:
            return UIImage(named: "php-bubble")!
        }
    }
    
}
