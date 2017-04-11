import UIKit

struct UsernameViewData {
    let text: String
    let messages: String
    let isValid: Bool
}

protocol UsernameViewControllerDelegate: class {
    func viewReady()
    func didChangeUsername(to text: String)
    func didTapNext(with text: String)
}

class UsernameViewController: UIViewController {
    
    weak var delegate: UsernameViewControllerDelegate?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var messagesTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewData: UsernameViewData? {
        didSet {
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.viewReady()
    }
    
    @IBAction func didChangeUsername(_ sender: Any) {
        delegate?.didChangeUsername(to: usernameText())
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        delegate?.didTapNext(with: usernameText())
    }
    
    private func usernameText() -> String {
        return usernameTextField.text ?? ""
    }

    private func refresh() {
        guard let viewData = viewData else { preconditionFailure() }
        if viewData.text != usernameText() {
            usernameTextField.text = viewData.text
        }
        messagesTextView.text = viewData.messages
        nextButton.isEnabled = viewData.isValid
    }
}
