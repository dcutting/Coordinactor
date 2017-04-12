import UIKit

protocol StartViewControllerDelegate: class {
    func didTapCancel()
    func didTapStart()
}

class StartViewController: UIViewController {
    
    weak var delegate: StartViewControllerDelegate?
    
    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.didTapCancel()
    }
    
    @IBAction func didTapStart(_ sender: Any) {
        delegate?.didTapStart()
    }
}
