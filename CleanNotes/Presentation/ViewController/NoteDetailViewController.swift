
import Foundation
import UIKit

final class NoteDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var detailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteNoteButton: UIButton!
    
    internal var viewModel: NoteDetailViewModelContract
    private var note: NoteModel?
    private var createdDate: String?
    
    init(viewModel: NoteDetailViewModelContract, note: NoteModel? = nil) {
        self.note = note
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.isScrollEnabled = false
        detailTextView.isScrollEnabled = false
        titleTextView.delegate = self
        detailTextView.delegate = self
        deleteNoteButton.isHidden = false
        populate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textViewDidChange(titleTextView)
        textViewDidChange(detailTextView)
    }
    
    private func populate() {
        guard let note = self.note else {
            self.createdDate = Date().isoString
            createdTimeLabel.text = self.createdDate?.isoToFormatted()
            deleteNoteButton.isHidden = true
            return
        }
        titleTextView.text = note.title
        createdTimeLabel.text = note.createdDate
        detailTextView.text = note.detail
    }
    
    @IBAction func deleteButtonTapped() {
        guard let id = note?.id else {
            Logger.debug("Note not found.")
            return
        }
        let alert = UIAlertController(
            title: "Delete Note",
            message: "Are you sure you want to delete this note?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteNote(id: id)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func backButtonTapped() {
        let titleText = (titleTextView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let detailText = (detailTextView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if titleText.isEmpty && !(detailText.isEmpty) {
            let alert = UIAlertController(title: "Validation", message: "Please enter a title.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        if titleText.isEmpty && detailText.isEmpty {
            viewModel.popToNoteListPage()
            return
        }
        let idToUse = note?.id ?? UUID().uuidString
        let newNote = NoteModel(
            id: idToUse,
            title: titleText,
            detail: detailText,
            createdDate: (note?.createdDate ?? self.createdDate) ?? Date().isoString
        )
        viewModel.saveNote(note: newNote)
    }
}




extension NoteDetailViewController: NoteDetailViewControllerContract {
    func showSuccessToast(_ message: String) {
        Logger.debug(message)
        viewModel.loadNoteListPage()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}




extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            titleTextView.placeholder = (titleTextView.text.isEmpty) ? "Title" : nil
            let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
            titleHeightConstraint.constant = newSize.height
        } else if textView == detailTextView {
            detailTextView.placeholder = (detailTextView.text.isEmpty) ? "detail" : nil
            let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
            detailHeightConstraint.constant = newSize.height
        }
        UIView.animate(withDuration: 0.2) {
            UIView.setAnimationsEnabled(false)
            self.view.layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
        }
    }
}
