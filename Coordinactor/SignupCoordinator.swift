import UIKit

protocol SignupCoordinatorDelegate: class {
    func didCancel()
    func didSucceed()
}

class SignupCoordinator {
    
    weak var delegate: SignupCoordinatorDelegate?
    
    let rootViewController: UIViewController
    var navigationController: UINavigationController!
    
    var usernameCoordinator: UsernameCoordinator?
    
    let errorPresenter = ErrorPresenter()
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        guard let signupViewController = loadViewController(named: "signup") as? SignupViewController else { return }
        signupViewController.delegate = self
        
        navigationController = UINavigationController(rootViewController: signupViewController)
        rootViewController.present(navigationController, animated: true)
    }
    
    func loadViewController(named name: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name)
    }
    
    func progress(to viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func complete() {
        rootViewController.dismiss(animated: true)
        delegate?.didSucceed()
    }
    
    func cancel() {
        rootViewController.dismiss(animated: true)
        delegate?.didCancel()
    }
}

extension SignupCoordinator: SignupViewControllerDelegate {
    
    func didTapCancel() {
        cancel()
    }
    
    func didTapStart() {
        usernameCoordinator = UsernameCoordinator(navigationController: navigationController)
        usernameCoordinator?.delegate = self
        usernameCoordinator?.start()
    }
}

extension SignupCoordinator: UsernameCoordinatorDelegate {
    
    func didSucceed() {
        guard let completeViewController = loadViewController(named: "complete") as? CompleteViewController else { return }
        completeViewController.navigationItem.setHidesBackButton(true, animated: true)
        completeViewController.delegate = self
        progress(to: completeViewController)
    }
    
    func didFail(with error: Error) {
        guard let errorViewController = loadViewController(named: "error") as? ErrorViewController else { return }
        errorViewController.message = errorPresenter.prepare(error: error)
        errorViewController.navigationItem.setHidesBackButton(true, animated: true)
        errorViewController.delegate = self
        progress(to: errorViewController)
    }
}

extension SignupCoordinator: ErrorViewControllerDelegate {
    
    func didTapRestart() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SignupCoordinator: CompleteViewControllerDelegate {

    func didTapDone() {
        complete()
    }
}
