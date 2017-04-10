import UIKit

protocol SignupCoordinatorDelegate: class {
    func didCancel()
}

class SignupCoordinator {
    
    weak var delegate: SignupCoordinatorDelegate?
    
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        guard let signupViewController = loadViewController(named: "signup") as? SignupViewController else { return }
        signupViewController.delegate = self
        rootViewController.present(signupViewController, animated: true)
    }
    
    func loadViewController(named name: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name)
    }
}

extension SignupCoordinator: SignupViewControllerDelegate {
    
    func didTapCancel() {
        rootViewController.dismiss(animated: true)
        delegate?.didCancel()
    }
    
    func didTapStart() {
        guard let usernameViewController = loadViewController(named: "username") as? UsernameViewController else { return }
        rootViewController.dismiss(animated: false)
        rootViewController.present(usernameViewController, animated: false)
    }
}
