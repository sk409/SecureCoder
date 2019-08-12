import UIKit

enum ProgramingLanguage: String, Decodable {
    
    case html
    case css
    case javaScript
    case php
    case sql
    
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
        case .sql:
            self = .sql
        }
    }
    
}
