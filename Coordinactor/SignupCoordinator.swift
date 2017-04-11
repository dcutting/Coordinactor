import UIKit

protocol SignupCoordinatorDelegate: class {
    func didSucceed()
    func didCancel()
}

class SignupCoordinator {
    
    weak var delegate: SignupCoordinatorDelegate?
    
    let rootViewController: UIViewController
    let navigationController = UINavigationController()
    
    var usernameCoordinator: UsernameCoordinator?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        guard let signupViewController = loadViewController(named: "signup") as? SignupViewController else { preconditionFailure() }
        signupViewController.delegate = self
        navigationController.viewControllers = [signupViewController]
    }
    
    func start() {
        presentSignup()
    }
}

extension SignupCoordinator {
    
    fileprivate func loadViewController(named name: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name)
    }
    
    fileprivate func presentSignup() {
        rootViewController.present(navigationController, animated: true)
    }
    
    fileprivate func dismissSignup() {
        navigationController.dismiss(animated: true)
    }
    
    fileprivate func restartSignup() {
        finishUsernameCoordinator()
        navigationController.popToRootViewController(animated: true)
    }
    
    fileprivate func progress(to viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SignupCoordinator: SignupViewControllerDelegate {
    
    func didTapCancel() {
        cancelSignup()
    }
    
    private func cancelSignup() {
        dismissSignup()
        delegate?.didCancel()
    }

    func didTapStart() {
        startUsernameCoordinator()
    }
    
    private func startUsernameCoordinator() {
        usernameCoordinator = UsernameCoordinator(navigationController: navigationController)
        usernameCoordinator?.delegate = self
        usernameCoordinator?.start()
    }
    
    fileprivate func finishUsernameCoordinator() {
        usernameCoordinator = nil
    }
}

extension SignupCoordinator: UsernameCoordinatorDelegate {
    
    func didSucceed() {
        showCompleteScreen()
    }
    
    private func showCompleteScreen() {
        guard let completeViewController = loadViewController(named: "complete") as? CompleteViewController else { return }
        completeViewController.navigationItem.setHidesBackButton(true, animated: true)
        completeViewController.delegate = self
        progress(to: completeViewController)
    }
    
    func didFail(with error: Error) {
        showErrorScreen(error: error)
    }
    
    private func showErrorScreen(error: Error) {
        guard let errorViewController = loadViewController(named: "error") as? ErrorViewController else { return }
        errorViewController.message = ErrorPresenter().prepare(error: error)
        errorViewController.navigationItem.setHidesBackButton(true, animated: true)
        errorViewController.delegate = self
        progress(to: errorViewController)
    }
}

extension SignupCoordinator: ErrorViewControllerDelegate {
    
    func didTapRestart() {
        restartSignup()
    }
}

extension SignupCoordinator: CompleteViewControllerDelegate {

    func didTapDone() {
        completeSignup()
    }

    private func completeSignup() {
        dismissSignup()
        delegate?.didSucceed()
    }
}
