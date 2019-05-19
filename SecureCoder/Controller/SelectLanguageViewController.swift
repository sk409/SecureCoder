import UIKit

class SelectLanguageViewController: UIViewController {
    
    
    @IBOutlet weak var htmlButton: UIButton!
    @IBOutlet weak var javaScriptButton: UIButton!
    @IBOutlet weak var phpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = self.navigationController else {
            return
        }
        view.backgroundColor = .baseColor
        navigationController.navigationBar.tintColor = .accentColor
        navigationController.navigationBar.barTintColor = .mainColor
        htmlButton.backgroundColor = .mainColor
        htmlButton.setTitleColor(.white, for: .normal)
        javaScriptButton.backgroundColor = .mainColor
        javaScriptButton.setTitleColor(.white, for: .normal)
        phpButton.backgroundColor = .mainColor
        phpButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func handleHTMLCSSButton(_ sender: Any) {
        transitionToSelectLessonViewController(lessonType: .htmlcss)
    }
    
    @IBAction func handleJavaScriptButton(_ sender: Any) {
        transitionToSelectLessonViewController(lessonType: .javaScript)
    }
    
    
    @IBAction func handlePHPButton(_ sender: Any) {
        transitionToSelectLessonViewController(lessonType: .php)
    }
    
    private func transitionToSelectLessonViewController(lessonType: LessonType) {
        guard let selectLessonViewController = storyboard?.instantiateViewController(withIdentifier: "SelectLessonViewController") as? SelectLessonViewController else {
            return
        }
        selectLessonViewController.setLessonType(lessonType)
        show(selectLessonViewController, sender: nil)
    }
    
    
}
