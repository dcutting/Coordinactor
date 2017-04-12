import UIKit

protocol SignupCoordinatorDelegate: class {
    func didSucceed()
    func didCancel()
}

class SignupCoordinator {
    
    weak var delegate: SignupCoordinatorDelegate?
    
    let presentingViewController: PresentingViewController
    var stackingViewController: StackingViewController
    
    var usernameCoordinator: UsernameCoordinator?
    
    init(presentingViewController: PresentingViewController) {
        self.presentingViewController = presentingViewController
        let startViewController = StartWireframe().make()
        stackingViewController = UINavigationController()
        stackingViewController.viewControllers = [startViewController]
        startViewController.delegate = self
    }
    
    func start() {
        presentSignup()
    }
}

extension SignupCoordinator {
    
    fileprivate func presentSignup() {
        presentingViewController.present(stackingViewController, animated: true, completion: nil)
    }
    
    fileprivate func dismissSignup() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func restartSignup() {
        finishUsernameCoordinator()
        stackingViewController.popToRootViewController(animated: true)
    }
    
    fileprivate func progress(to viewController: UIViewController) {
        stackingViewController.pushViewController(viewController, animated: true)
    }
}

extension SignupCoordinator: StartViewControllerDelegate {
    
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
        usernameCoordinator = UsernameCoordinator(stackingViewController: stackingViewController)
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
        let completeViewController = CompleteWireframe().make()
        completeViewController.navigationItem.setHidesBackButton(true, animated: true)
        completeViewController.delegate = self
        progress(to: completeViewController)
    }
    
    func didFail(with error: Error) {
        showErrorScreen(error: error)
    }
    
    private func showErrorScreen(error: Error) {
        let errorViewController = ErrorWireframe().make()
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
