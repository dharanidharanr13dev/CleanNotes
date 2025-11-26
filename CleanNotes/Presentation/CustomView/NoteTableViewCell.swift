
import UIKit


class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    static let reuseIdentifier = "NoteCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 8
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byTruncatingTail
        detailLabel.numberOfLines = 5
        detailLabel.lineBreakMode = .byTruncatingTail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: NotePresentationModel) {
        titleLabel.attributedText = viewModel.attributedTitle
        detailLabel.attributedText = viewModel.detailText
    }
}
