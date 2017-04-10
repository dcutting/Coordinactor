import UIKit

protocol UsernameViewControllerDelegate: class {
    func didChangeUsername(to text: String)
    func didTapNext()
}

class UsernameViewController: UIViewController {
    
    weak var delegate: UsernameViewControllerDelegate?
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func didChangeUsername(_ sender: Any) {
        let text = usernameTextField.text ?? ""
        delegate?.didChangeUsername(to: text)
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        delegate?.didTapNext()
    }
}
