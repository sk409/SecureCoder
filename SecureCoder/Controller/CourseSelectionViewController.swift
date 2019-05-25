import UIKit

class CourseSelectionViewController: UIViewController {
    
    var language: ProgramingLanguage?
    
    var courses = [
        ProgramingLanguage.html: ["HTML&CSSに触れてみよう"],
        .javaScript: ["JavaScriptに触れてみよう"],
        .php: ["PHPに触れてみよう"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupSubviews() {
        
    }
    
}
