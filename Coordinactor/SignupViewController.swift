import UIKit

protocol SignupViewControllerDelegate: class {
    func didTapCancel()
    func didTapStart()
}

class SignupViewController: UIViewController {
    
    weak var delegate: SignupViewControllerDelegate?
    
    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.didTapCancel()
    }
    
    @IBAction func didTapStart(_ sender: Any) {
        delegate?.didTapStart()
    }
}
