import UIKit

protocol PresentingViewController: class {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
}

extension PresentingViewController {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func dismiss(animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        dismiss(animated: flag, completion: completion)
    }
}

extension UIViewController: PresentingViewController {}
