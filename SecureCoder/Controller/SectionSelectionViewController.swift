import UIKit

class SectionSelectionViewController: UIViewController {
    
    var course: Course?
    
    let headerView = UIView()
    let courseTitleLabel = UILabel()
    let backButton = UIButton()
    let sectionsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(backButton)
        headerView.addSubview(courseTitleLabel)
        view.addSubview(sectionsTableView)
        headerView.backgroundColor = .systemBlue
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            ])
        courseTitleLabel.text = course?.title
        courseTitleLabel.font = .boldSystemFont(ofSize: 20)
        courseTitleLabel.numberOfLines = 0
        courseTitleLabel.textAlignment = .center
        courseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            courseTitleLabel.leadingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.leadingAnchor),
            courseTitleLabel.trailingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.trailingAnchor),
            courseTitleLabel.centerXAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerXAnchor),
            courseTitleLabel.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
            ])
        backButton.setBackgroundImage(UIImage(named: "back-icon"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            ])
        sectionsTableView.dataSource = self
        sectionsTableView.delegate = self
        sectionsTableView.tableFooterView = UIView()
        sectionsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionsTableView.leadingAnchor.constraint(equalTo: headerView.trailingAnchor),
            sectionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sectionsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            sectionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
    
    @objc
    private func handleBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

extension SectionSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = course?.sections[indexPath.row].title
        cell.textLabel?.font = .systemFont(ofSize: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = course?.sections[indexPath.row]
        let lessonSelectionViewController = LessonSelectionViewController()
        lessonSelectionViewController.section = section
        present(lessonSelectionViewController, animated: true)
    }
    
}
