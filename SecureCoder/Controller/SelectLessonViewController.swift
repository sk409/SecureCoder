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
        guard let sections = Lesson.sections(type: lessonType) else {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sections = Lesson.sections(type: lessonType) else {
            return nil
        }
        let header = UILabel()
        header.text = sections[section]
        header.backgroundColor = .lightGray
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let titles = Lesson.titles(type: lessonType, section: section) else {
            return 0
        }
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let titles = Lesson.titles(type: lessonType, section: indexPath.section) else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sections = Lesson.sections(type: lessonType) else {
            return
        }
        guard let titles = Lesson.titles(type: lessonType, section: indexPath.section) else {
            return
        }
//        guard let codeEditorViewController = storyboard?.instantiateViewController(withIdentifier: "CodeEditorViewController") as? CodeEditorViewController else {
//            return
//        }
//        let lesson = Lesson(type: lessonType, section: sections[indexPath.section], title: titles[indexPath.row])
//        codeEditorViewController.setLesson(lesson)
//        show(codeEditorViewController, sender: nil)
        guard let descriptionImageCollectionViewController = storyboard?.instantiateViewController(withIdentifier: "DescriptionPageController") as? DescriptionImageCollectionViewController else {
            return
        }
        let lesson = Lesson(type: lessonType, section: sections[indexPath.section], title: titles[indexPath.row])
        descriptionImageCollectionViewController.setLesson(lesson)
        show(descriptionImageCollectionViewController, sender: nil)
    }
    
}
