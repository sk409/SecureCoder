import Foundation
import UIKit

struct CodeCompletionResult {
    let insertionText: String
    let insertionLocation: Int
    let caretLocation: Int
}

protocol CodeAutoCompleter {
    
    func complete(_ text: String, selectedLocation: Int) -> CodeCompletionResult
    
}
