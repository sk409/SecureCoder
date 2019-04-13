import UIKit

class SelectLessonViewController: UIViewController {
    
    @IBOutlet weak private var lessonTableView: UITableView!
    
    private var lessonType = LessonType.htmlcss
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLessonTableView()
    }
    
    func setLessonType(_ lessonType: LessonType) {
        self.lessonType = lessonType
    }
    
    private func setupLessonTableView() {
        lessonTableView.tableFooterView = UIView()
    }
    
}

extension SelectLessonViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = Lesson.sections[lessonType] else {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = Lesson.sections[lessonType]?[section]
        header.backgroundColor = .lightGray
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Lesson.titles[lessonType]?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = Lesson.titles[lessonType]?[indexPath.section][indexPath.row] ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let codeEditorViewController = storyboard?.instantiateViewController(withIdentifier: "CodeEditorViewController") as? CodeEditorViewController else {
            return
        }
        let lesson = Lesson(type: lessonType, sectionNumber: indexPath.section, titleNumber: indexPath.row)
        codeEditorViewController.setLesson(lesson)
        show(codeEditorViewController, sender: nil)
    }
    
}
