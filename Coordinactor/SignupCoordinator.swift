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
        let startViewController = StartWireframe().make()
        startViewController.delegate = self
        navigationController.viewControllers = [startViewController]
    }
    
    func start() {
        presentSignup()
    }
}

extension SignupCoordinator {
    
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
