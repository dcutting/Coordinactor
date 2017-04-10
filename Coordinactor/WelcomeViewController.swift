import UIKit

protocol WelcomeViewControllerDelegate: class {
    func didTapSignup()
}

class WelcomeViewController: UIViewController {
    
    weak var delegate: WelcomeViewControllerDelegate?
    
    @IBAction func didTapSignup(_ sender: Any) {
        delegate?.didTapSignup()
    }
}
