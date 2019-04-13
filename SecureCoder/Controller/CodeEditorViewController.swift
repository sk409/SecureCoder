import UIKit

final class CodeEditorViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak private var editorTextView: EditorTextView!
    @IBOutlet weak private var editorTextViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var directoryTableView: UITableView!
    @IBOutlet weak private var directoryTableViewWidthConstraint: NSLayoutConstraint!
    
    
    private var lesson: Lesson?
    private var workingFile: File?
    private var codeAutoCompleter: CodeAutoCompleter?
    private var codeSyntaxHighlighter: CodeSyntaxHighlighter?
    private var defaultColor = UIColor.white
    private var font = UIFont.systemFont(ofSize: 18)
    private var isEmptyCharacterEntered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCodeAutoCompleter()
        setupCodeSyntaxHighlighter()
        setupWorkingFile()
        setupEditorTextView()
        setupDirectoryTableView()
        setupCodeAutoCompleter()
        setupCodeSyntaxHighlighter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveFiles()
    }
    
    @IBAction func initializeWorkingFile(_ sender: Any) {
        guard let workingFile = self.workingFile else {
            return
        }
        workingFile.initialize()
        workingFile.save()
        readWorkingFile()
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
    
    private func setupCodeAutoCompleter() {
        codeAutoCompleter = PHPAutoCompleter()
    }
    
    private func setupCodeSyntaxHighlighter() {
        codeSyntaxHighlighter = PHPSyntaxHighlighter(defaultColor: defaultColor, font: font)
    }
    
    private func setupWorkingFile() {
        guard let lesson = self.lesson else {
            return
        }
        workingFile = lesson.indexFile
        editorTextView.isEditable = lesson.indexFile.editable
    }
    
    private func setupEditorTextView() {
        editorTextViewWidthConstraint.constant = (view.bounds.width - directoryTableViewWidthConstraint.constant)
        editorTextView.autocorrectionType = .no
        editorTextView.autocapitalizationType = .none
        editorTextView.font = font
        readWorkingFile()
    }
    
    private func setupDirectoryTableView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDirectoryTableViewPanGesture(_:)))
        directoryTableView.addGestureRecognizer(panGestureRecognizer)
        directoryTableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func readWorkingFile() {
        guard let workingFile = self.workingFile else {
            return
        }
        editorTextView.text = workingFile.text
        decorateSyntaxHighlight(text: editorTextView.text!, caretLocation: editorTextView.text!.count, isSynchronized: true)
        fitWidthEditorTextView()
    }
    
    private func changeWorkingFile(_ file: File) {
        workingFile = file
        editorTextView.isEditable = file.editable
        readWorkingFile()
    }
    
    private func completeCode() {
        guard let codeAutoCompleter = self.codeAutoCompleter else {
            return
        }
        let completionResult = codeAutoCompleter.complete(editorTextView.text, selectedLocation: editorTextView.selectedRange.location)
        let insertionAttributeText = NSAttributedString(string: completionResult.insertionText, attributes: [NSAttributedString.Key.foregroundColor: defaultColor, NSAttributedString.Key.font: font])
        let attributedText = NSMutableAttributedString(attributedString: editorTextView.attributedText!)
        attributedText.insert(insertionAttributeText, at: completionResult.insertionLocation)
        editorTextView.attributedText = attributedText
        editorTextView.selectedRange.location = completionResult.caretLocation
        decorateSyntaxHighlight(text: attributedText.string, caretLocation: completionResult.caretLocation, isSynchronized: false)
    }
    
    private func decorateSyntaxHighlight(text: String, caretLocation: Int, isSynchronized: Bool) {
        guard let codeSyntaxHighlighter = self.codeSyntaxHighlighter else {
            return
        }
        if isSynchronized {
            editorTextView.attributedText = codeSyntaxHighlighter.syntaxHighlight(editorTextView.text!)
            editorTextView.selectedRange.location = caretLocation
        } else {
            DispatchQueue.global().async {
                let decorated = codeSyntaxHighlighter.syntaxHighlight(text)
                DispatchQueue.main.async {
                    if self.editorTextView.text == decorated.string {
                        self.editorTextView.attributedText = decorated
                        self.editorTextView.selectedRange.location = caretLocation
                    }
                }
            }
        }
    }
    
    private func fitWidthEditorTextView() {
        let minWidth = view.bounds.width - directoryTableViewWidthConstraint.constant
        editorTextViewWidthConstraint.constant = max(minWidth, editorTextView.maxLineWidth)
    }
    
//    private func scrollToBestPosition() {
//        let lineWidth = editorTextView.lineWidth(location: editorTextView.selectedRange.location - 1)
//        let minX = editorTextView.contentOffset.x
//        let maxX = minX + (view.bounds.width - directoryTableView.bounds.width)
//        if lineWidth < minX || maxX < lineWidth {
//            editorTextView.contentOffset.x = lineWidth
//        }
//    }
    
    @objc private func saveFiles() {
        guard let lesson = self.lesson else {
            return
        }
        lesson.files.forEach { $0.save() }
    }
    
    @objc private func handleDirectoryTableViewPanGesture(_ sender: UIPanGestureRecognizer) {
        let speed: CGFloat = 0.01
        let velocity = sender.velocity(in: directoryTableView).x
        let constant = directoryTableViewWidthConstraint.constant
        let minWidth: CGFloat = 44
        let maxWidth = view.bounds.width * 0.6
        let width = min(maxWidth, max(minWidth, constant + (velocity * speed)))
        directoryTableViewWidthConstraint.constant = width
    }
    
}

extension CodeEditorViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else {
            return
        }
        guard let workingFile = self.workingFile else {
            return
        }
        if isEmptyCharacterEntered {
            decorateSyntaxHighlight(text: editorTextView.text!, caretLocation: editorTextView.selectedRange.location, isSynchronized: false)
        } else {
            completeCode()
        }
        fitWidthEditorTextView()
        //scrollToBestPosition()
        workingFile.setText(editorTextView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        isEmptyCharacterEntered = text.isEmpty
        return true
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
        cell.textLabel?.textColor = lesson.files[indexPath.row].editable ? UIColor.turquoiseBlue : .white
        cell.textLabel?.text = lesson.files[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lesson = self.lesson else {
            return
        }
        let file = lesson.files[indexPath.row]
        changeWorkingFile(file)
    }
    
}
