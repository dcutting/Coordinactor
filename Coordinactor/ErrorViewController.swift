import UIKit

protocol ErrorViewControllerDelegate: class {
    func didTapRestart()
}

class ErrorViewController: UIViewController {
    
    weak var delegate: ErrorViewControllerDelegate?
    
    @IBOutlet weak var messageTextView: UITextView!

    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.text = message
    }
    
    @IBAction func didTapRestart(_ sender: Any) {
        delegate?.didTapRestart()
    }
}
