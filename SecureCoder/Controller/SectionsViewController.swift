import UIKit

class SectionsViewController: UIViewController {
    
    private static let cellID = "CELL"
    
    var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        let headerView = UIView()
        view.addSubview(headerView)
        headerView.backgroundColor = course?.language.themeColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            headerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1 / 4)
            ])
        let headerImageView = UIImageView()
        headerView.addSubview(headerImageView)
        headerImageView.image = course?.language.iconImage
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerImageView.centerXAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerXAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
            headerImageView.widthAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.widthAnchor, multiplier: 1 / 3),
            headerImageView.heightAnchor.constraint(equalTo: headerImageView.safeAreaLayoutGuide.heightAnchor),
            ])
        let courseTitleLabel = UILabel()
        headerView.addSubview(courseTitleLabel)
        courseTitleLabel.text = course?.title
        courseTitleLabel.textColor = course?.language.tintColor
        courseTitleLabel.font = .boldSystemFont(ofSize: 18)
        courseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            courseTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            courseTitleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 8),
            ])
        let bodyView = UIView()
        view.addSubview(bodyView)
        bodyView.backgroundColor = .white
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: headerView.trailingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bodyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        let sectionsTableView = UITableView()
        view.addSubview(sectionsTableView)
        sectionsTableView.dataSource = self
        sectionsTableView.delegate = self
        sectionsTableView.separatorStyle = .none
        sectionsTableView.tableFooterView = UIView()
        sectionsTableView.register(SectionCardTableViewCell.self, forCellReuseIdentifier: SectionsViewController.cellID)
        sectionsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionsTableView.centerXAnchor.constraint(equalTo: bodyView.centerXAnchor),
            sectionsTableView.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor, constant: 16),
            sectionsTableView.bottomAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.bottomAnchor),
            sectionsTableView.widthAnchor.constraint(equalTo: bodyView.widthAnchor, multiplier: 0.8),
            ])
        let backButtonSize: CGFloat = 44
        let backButton = UIButton(type: .system)
        view.addSubview(backButton)
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        backButton.layer.cornerRadius = (backButtonSize / 2)
        backButton.setTitle("←", for: .normal)
        backButton.setTitleColor(course?.language.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: backButtonSize),
            ])
    }
    
    @objc
    private func handleTransitionToCodeEditorViewControllerButton(_ sender: UIButton) {
        guard let section = (sender as? SectionButton)?.section else {
            return
        }
        let lesson = section.lessons.first
        let codeViewController = CodeEditorViewController()
        codeViewController.lesson = lesson
        present(codeViewController, animated: true)
    }
    
    @objc
    private func handleBackButtonTouchUpInsideEvent(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}


extension SectionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: SectionsViewController.cellID) as? SectionCardTableViewCell else {
            return UITableViewCell()
        }
        let section = course?.sections[indexPath.row]
        sectionCardTableViewCell.language = course?.language
        sectionCardTableViewCell.section = section
        sectionCardTableViewCell.transitionToCodeViewControllerButton.section = section
        sectionCardTableViewCell.transitionToCodeViewControllerButton.addTarget(self, action: #selector(handleTransitionToCodeEditorViewControllerButton(_:)), for: .touchUpInside)
        return sectionCardTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
