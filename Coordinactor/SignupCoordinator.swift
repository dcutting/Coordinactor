import UIKit

protocol SignupCoordinatorDelegate: class {
    func didCancel()
    func didSucceed()
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
    
    func progress(to viewController: UIViewController) {
        rootViewController.dismiss(animated: false)
        rootViewController.present(viewController, animated: false)
    }
}

extension SignupCoordinator: SignupViewControllerDelegate {
    
    func didTapCancel() {
        rootViewController.dismiss(animated: true)
        delegate?.didCancel()
    }
    
    func didTapStart() {
        guard let usernameViewController = loadViewController(named: "username") as? UsernameViewController else { return }
        usernameViewController.delegate = self
        progress(to: usernameViewController)
    }
}

extension SignupCoordinator: UsernameViewControllerDelegate {
    
    func didChangeUsername(to text: String) {
        print(text)
    }
    
    func didTapNext() {
        guard let waitingViewController = loadViewController(named: "waiting") as? WaitingViewController else { return }
        progress(to: waitingViewController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.succeedOrFail()
        }
    }
    
    func succeedOrFail() {
        if 0 == arc4random() % 2 {
            success()
        } else {
            failure()
        }
    }
    
    func success() {
        guard let completeViewController = loadViewController(named: "complete") as? CompleteViewController else { return }
        completeViewController.delegate = self
        progress(to: completeViewController)
    }
    
    func failure() {
        guard let errorViewController = loadViewController(named: "error") as? ErrorViewController else { return }
        errorViewController.delegate = self
        progress(to: errorViewController)
    }
}

extension SignupCoordinator: ErrorViewControllerDelegate {
    
    func didTapRestart() {
        rootViewController.dismiss(animated: false)
        start()
    }
}

extension SignupCoordinator: CompleteViewControllerDelegate {

    func didTapDone() {
        rootViewController.dismiss(animated: true)
        delegate?.didSucceed()
    }
}
