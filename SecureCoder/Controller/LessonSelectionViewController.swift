import UIKit

class LessonSelectionViewController: UIViewController {
    
    var section: Section?
    
    let backButton = UIButton()
    let headerView = UIView()
    let sectionTitleLabel = UILabel()
    let bodyView = UIView()
    let sectionDescriptionTextView = UITextView()
    let experienceButton = UIButton()
    let takeMeasuresButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(backButton)
        headerView.addSubview(sectionTitleLabel)
        view.addSubview(bodyView)
        bodyView.addSubview(sectionDescriptionTextView)
        bodyView.addSubview(experienceButton)
        bodyView.addSubview(takeMeasuresButton)
        backButton.setBackgroundImage(UIImage(named: "cross-icon"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.trailingAnchor.constraint(equalTo: takeMeasuresButton.trailingAnchor),
            backButton.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor)
            ])
        headerView.backgroundColor = .systemBlue
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            ])
        sectionTitleLabel.text = section?.title
        sectionTitleLabel.font = .boldSystemFont(ofSize: 20)
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionTitleLabel.leadingAnchor.constraint(equalTo: sectionDescriptionTextView.leadingAnchor),
            sectionTitleLabel.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
            ])
        bodyView.backgroundColor = .white
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            bodyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        sectionDescriptionTextView.isEditable = false
        sectionDescriptionTextView.isSelectable = false
        sectionDescriptionTextView.isScrollEnabled = false
        sectionDescriptionTextView.text = section?.description
        sectionDescriptionTextView.font = .systemFont(ofSize: 18)
        sectionDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionDescriptionTextView.centerXAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.centerXAnchor),
            sectionDescriptionTextView.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor),
            sectionDescriptionTextView.widthAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            sectionDescriptionTextView.heightAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.75)
            ])
        experienceButton.backgroundColor = .systemBlue
        experienceButton.setTitle("体験する", for: .normal)
        experienceButton.addTarget(self, action: #selector(transitionToLessonViewController(_:)), for: .touchUpInside)
        experienceButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            experienceButton.leadingAnchor.constraint(equalTo: sectionDescriptionTextView.leadingAnchor),
            experienceButton.topAnchor.constraint(equalTo: sectionDescriptionTextView.bottomAnchor),
            experienceButton.bottomAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            experienceButton.widthAnchor.constraint(equalTo: experienceButton.heightAnchor, multiplier: 2),
            ])
        takeMeasuresButton.backgroundColor = .systemBlue
        takeMeasuresButton.setTitle("対策する", for: .normal)
        takeMeasuresButton.addTarget(self, action: #selector(transitionToLessonViewController(_:)), for: .touchUpInside)
        takeMeasuresButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            takeMeasuresButton.trailingAnchor.constraint(equalTo: sectionDescriptionTextView.trailingAnchor),
            takeMeasuresButton.bottomAnchor.constraint(equalTo: experienceButton.bottomAnchor),
            takeMeasuresButton.widthAnchor.constraint(equalTo: experienceButton.widthAnchor),
            takeMeasuresButton.heightAnchor.constraint(equalTo: experienceButton.heightAnchor),
            ])
    }
    
    @objc
    private func transitionToLessonViewController(_ sender: UIButton) {
        let lesson = (sender == experienceButton) ? section?.unsafeLesson : section?.safeLesson
        let lessonViewController = LessonViewController()
        lessonViewController.lesson = lesson
        present(lessonViewController, animated: true)
    }
    
    @objc
    private func handleBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
