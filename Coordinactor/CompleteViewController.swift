import UIKit

protocol CompleteViewControllerDelegate: class {
    func didTapDone()
}

class CompleteViewController: UIViewController {
    
    weak var delegate: CompleteViewControllerDelegate?
    
    @IBAction func didTapDone(_ sender: Any) {
        delegate?.didTapDone()
    }
}
