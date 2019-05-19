import UIKit

final class CodeEditorViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var editorScrollView: UIScrollView!
    @IBOutlet weak private var editorTextView: EditorTextView!
    @IBOutlet weak private var editorTextViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var directoryTableView: UITableView!
    @IBOutlet weak private var directoryTableViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomControlsContainerView: UIView!
    @IBOutlet weak var bottomControlsContainerBottomConstraint: NSLayoutConstraint!
    
    
    private var lesson: Lesson?
    private var isEmptyCharacterEntered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditorTextView()
        setupDirectoryTableView()
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let lesson = self.lesson else {
            return
        }
        guard let file = editorTextView.file else {
            return
        }
        lesson.save(file, with: editorTextView.text)
    }
    
    @IBAction func initializeWorkingFile(_ sender: Any) {
        guard let lesson = self.lesson else {
            return
        }
        guard let workingFile = editorTextView.file else {
            return
        }
        lesson.initialize(fileIndex: workingFile.index)
        lesson.save(workingFile, with: workingFile.text)
        editorTextView.file = workingFile
        fitSizeEditorTextView()
    }
    
    @IBAction func transitionToPreviewViewController(_ sender: Any) {
        guard let lesson = self.lesson else {
            return
        }
        guard let previewViewController = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController else {
            return
        }
        previewViewController.setLesson(lesson)
        show(previewViewController, sender: nil)
    }
    
    
    func setLesson(_ lesson: Lesson) {
        self.lesson = lesson
    }
    
    func fitSizeEditorTextView() {
        let size = editorTextView.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
        editorTextViewWidthConstraint.constant = size.width
    }
    
    private func setupEditorTextView() {
        guard let indexFile = lesson?.indexFile else {
            return
        }
        editorTextViewWidthConstraint.constant = (view.bounds.width - directoryTableViewWidthConstraint.constant)
        editorTextView.autocorrectionType = .no
        editorTextView.autocapitalizationType = .none
        editorTextView.file = indexFile
        editorTextView.font = .systemFont(ofSize: 18)
        fitSizeEditorTextView()
    }
    
    private func setupDirectoryTableView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDirectoryTableViewPanGesture(_:)))
        directoryTableView.addGestureRecognizer(panGestureRecognizer)
        directoryTableView.separatorInset.left = 0
        directoryTableView.tableFooterView = UIView()
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func handleDirectoryTableViewPanGesture(_ sender: UIPanGestureRecognizer) {
        let speed: CGFloat = 0.01
        let velocity = sender.velocity(in: directoryTableView).x
        let constant = directoryTableViewWidthConstraint.constant
        let minWidth: CGFloat = 44
        let maxWidth = view.bounds.width * 0.6
        let width = min(maxWidth, max(minWidth, constant + (velocity * speed)))
        directoryTableViewWidthConstraint.constant = width
    }
    
    @objc
    private func handleKeyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        guard let keyboardDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) else {
            return
        }
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        let isShowing = (notification.name == UIResponder.keyboardWillShowNotification)
        let safeAreaBottomInset = keyWindow.safeAreaInsets.bottom
        bottomControlsContainerBottomConstraint.constant = isShowing ? (-keyboardHeight + safeAreaBottomInset) : 0
        UIView.animate(withDuration: keyboardDuration) {
            self.bottomControlsContainerView.layoutIfNeeded()
        }
    }
    
}

extension CodeEditorViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else {
            return
        }
        if !isEmptyCharacterEntered {
            editorTextView.completeCode()
        }
        editorTextView.decorateSyntaxHighlight(caretLocation: editorTextView.selectedRange.location, synchronize: false)
        editorTextView.autoCorrect()
        fitSizeEditorTextView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        isEmptyCharacterEntered = text.isEmpty
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let font = textView.font else {
            return
        }
        var line = ""
        for index in (0..<textView.selectedRange.location + textView.selectedRange.length).reversed() {
            if textView.text[index] == "\n" {
                break
            }
            line = String(textView.text[index]) + line
        }
        let lineSize = line.size(withAttributes: [NSAttributedString.Key.font: font])
        let paddingRight: CGFloat = 32
        editorScrollView.contentOffset.x = max(0, (lineSize.width - editorScrollView.bounds.width) + paddingRight)
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
}

extension CodeEditorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lesson = self.lesson else {
            return 0
        }
        return lesson.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let lesson = self.lesson else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        cell.backgroundColor = tableView.backgroundColor
        cell.textLabel?.textColor = lesson.files[indexPath.row].isEditable ? UIColor.turquoiseBlue : .white
        cell.textLabel?.text = lesson.files[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lesson = self.lesson else {
            return
        }
        guard let file = editorTextView.file else {
            return
        }
        lesson.save(file, with: editorTextView.text)
        editorTextView.file = lesson.files[indexPath.row]
        fitSizeEditorTextView()
    }
    
}
