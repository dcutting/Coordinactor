import UIKit

struct UsernameViewData {
    let text: String
    let messages: String
    let isValid: Bool
}

protocol UsernameViewControllerDelegate: class {
    func viewReady(completion: @escaping (UsernameViewData) -> Void)
    func didChangeUsername(to text: String, completion: @escaping (UsernameViewData) -> Void)
    func didTapNext(with text: String, completion: @escaping (UsernameViewData) -> Void)
}

class UsernameViewController: UIViewController {
    
    weak var delegate: UsernameViewControllerDelegate?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var messagesTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.viewReady { [weak self] viewData in
            self?.refresh(viewData)
        }
    }
    
    @IBAction func didChangeUsername(_ sender: Any) {
        let text = usernameText()
        delegate?.didChangeUsername(to: text) { [weak self] viewData in
            self?.refresh(viewData)
        }
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        let text = usernameText()
        delegate?.didTapNext(with: text) { [weak self] viewData in
            self?.refresh(viewData)
        }
    }
    
    private func usernameText() -> String {
        return usernameTextField.text ?? ""
    }
    
    private func refresh(_ viewData: UsernameViewData) {
        if viewData.text != usernameText() {
            usernameTextField.text = viewData.text
        }
        if viewData.messages != messagesTextView.text {
            messagesTextView.text = viewData.messages
        }
        nextButton.isEnabled = viewData.isValid
    }
}
