import UIKit

protocol ErrorViewControllerDelegate: class {
    func didTapRestart()
}

class ErrorViewController: UIViewController {
    
    weak var delegate: ErrorViewControllerDelegate?
    
    @IBAction func didTapRestart(_ sender: Any) {
        delegate?.didTapRestart()
    }
}
