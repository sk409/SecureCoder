//import UIKit
//import WebKit
//
//class PreviewViewController: UIViewController {
//    
//    @IBOutlet weak private var webView: WKWebView!
//    
//    private var lesson: Lesson?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        webView.uiDelegate = self
//        guard let lesson = self.lesson else {
//            return
//        }
//        guard AnswerChecker.check(lesson: lesson) else {
//            return
//        }
//        guard let urlString = lesson.absolutePreviewIndexFileURLString()?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            return
//        }
//        guard let url = URL(string: urlString) else {
//            return
//        }
//        webView.load(URLRequest(url: url))
//    }
//    
//    func setLesson(_ lesson: Lesson) {
//        self.lesson = lesson
//    }
//    
//}
//
//extension PreviewViewController: WKUIDelegate {
//    
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
//        let otherAction = UIAlertAction(title: "OK", style: .default) { _ in
//            completionHandler()
//        }
//        alertController.addAction(otherAction)
//        present(alertController, animated: true)
//    }
//    
//    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
//        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
//            action in completionHandler(false)
//        }
//        let okAction = UIAlertAction(title: "OK", style: .default) {
//            action in completionHandler(true)
//        }
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        present(alertController, animated: true)
//    }
//    
//    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
//        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
//        let okHandler: () -> Void = {
//            if let textField = alertController.textFields?.first {
//                completionHandler(textField.text)
//            } else {
//                completionHandler("")
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
//            action in completionHandler("")
//        }
//        let okAction = UIAlertAction(title: "OK", style: .default) {
//            action in okHandler()
//        }
//        alertController.addTextField() { $0.text = defaultText }
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        present(alertController, animated: true)
//    }
//    
//}
