
import UIKit


final class NoteListViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteListTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addNoteView: UIView!
    
    internal var viewModel: NoteListViewModelContract
    private var notesModel: [NotePresentationModel] = []
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    init(viewModel: NoteListViewModelContract) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        initialSetUp()
        setupKeyboardDismissGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getNotes()
    }
    
    func initialSetUp() {
        titleLabel.text = "Notes"
        noteListTableView.delegate = self
        noteListTableView.dataSource = self
        noteListTableView.separatorInset = .zero
        noteListTableView.layoutMargins = .zero
        noteListTableView.registerNib(NoteTableViewCell.self)
        
        searchView.layer.cornerRadius = 7
        searchView.layer.borderWidth = 0.7
        searchView.layer.borderColor = UIColor.systemYellow.cgColor
        searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        addNoteView.layer.cornerRadius = 25
        addNoteView.layer.borderWidth = 1.5
        addNoteView.layer.borderColor = UIColor.systemBackground.cgColor
    }
    
    @IBAction func didTapAddNote() {
        viewModel.didTapAddNote()
    }
    @objc private func textDidChange(_ textField: UITextField) {
        viewModel.searchNotes(textField.text ?? "")
    }
    
    private func bindViewModel() {
        viewModel.stateDidChange = { [weak self] state in
            guard let self else { return }
            switch state {
            case .loading:
                loadingIndicator.startAnimating()
            case .loaded(let notes):
                loadingIndicator.stopAnimating()
                self.loadNotes(notes)
            case .error(let message):
                loadingIndicator.stopAnimating()
                self.showError(message)
            }
        }
    }
    
    private func loadNotes(_ notes: [NotePresentationModel]) {
        self.notesModel = notes
        if notes.isEmpty {
            noteListTableView.setEmptyMessage("No Notes Found !")
        } else {
            noteListTableView.restore()
        }
        self.noteListTableView.reloadData()
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}




extension NoteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let modelData = notesModel[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: modelData)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath.row)
    }
}
