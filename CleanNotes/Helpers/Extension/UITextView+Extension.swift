
import Foundation
import UIKit
import ObjectiveC


private var placeholderLabelKey: UInt8 = 0

extension UITextView {

    @IBInspectable var placeholder: String? {
        get {
            return placeholderLabel?.text
        }
        set {
            if placeholderLabel == nil {
                let label = UILabel()
                label.textColor = .placeholderText
                label.numberOfLines = 0
                label.font = self.font
                label.translatesAutoresizingMaskIntoConstraints = false
                addSubview(label)

                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textContainerInset.left + textContainer.lineFragmentPadding),
                    label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(textContainerInset.right + textContainer.lineFragmentPadding)),
                    label.topAnchor.constraint(equalTo: self.topAnchor, constant: textContainerInset.top),
                ])

                self.placeholderLabel = label

                NotificationCenter.default.addObserver(self,
                    selector: #selector(textDidChange),
                    name: UITextView.textDidChangeNotification,
                    object: self)
            }
            placeholderLabel?.text = newValue
            placeholderLabel?.isHidden = !text.isEmpty
        }
    }

    private var placeholderLabel: UILabel? {
        get { objc_getAssociatedObject(self, &placeholderLabelKey) as? UILabel }
        set { objc_setAssociatedObject(self, &placeholderLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc internal func textDidChange() {
        placeholderLabel?.isHidden = !text.isEmpty
    }
}
