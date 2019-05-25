import UIKit

class SelectLanguageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.navigationBar.tintColor = .nileBlue
        navigationController.navigationBar.barTintColor = .darkBlue
    }
    
    @IBAction func handleHTMLCSSButton(_ sender: Any) {
        //transitionToSelectLessonViewController(lessonType: .htmlcss)
    }
    
    @IBAction func handleJavaScriptButton(_ sender: Any) {
        //transitionToSelectLessonViewController(lessonType: .javaScript)
    }
    
    
    @IBAction func handlePHPButton(_ sender: Any) {
        //transitionToSelectLessonViewController(lessonType: .php)
    }
    
//    private func transitionToSelectLessonViewController(lessonType: LessonType) {
//        guard let selectLessonViewController = storyboard?.instantiateViewController(withIdentifier: "SelectLessonViewController") as? SelectLessonViewController else {
//            return
//        }
//        selectLessonViewController.setLessonType(lessonType)
//        show(selectLessonViewController, sender: nil)
//    }
    
    
}
