import UIKit

struct UsernameViewData {
    let text: String
    let messages: [String]
}

protocol UsernameViewControllerDelegate: class {
    func didChangeUsername(to text: String, completion: (UsernameViewData) -> Void)
    func didTapNext()
}

class UsernameViewController: UIViewController {
    
    weak var delegate: UsernameViewControllerDelegate?
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func didChangeUsername(_ sender: Any) {
        let text = usernameTextField.text ?? ""
        delegate?.didChangeUsername(to: text) { viewData in
            print("\(viewData)")
        }
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        delegate?.didTapNext()
    }
}
