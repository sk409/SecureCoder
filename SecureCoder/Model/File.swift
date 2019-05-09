import Foundation

class File: NSObject {
    
    let name: String
    let `extension`: String
    let isEditable: Bool
    let index: Int
    private(set) var text = ""
    
    init(name: String, text: String, index: Int, isEditable: Bool) {
        self.name = name
        self.extension = NSString(string: name).pathExtension
        self.text = text
        self.index = index
        self.isEditable = isEditable
    }
    
    func setText(_ text: String) {
        self.text = text
    }
    
}
