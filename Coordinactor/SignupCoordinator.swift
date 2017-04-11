import UIKit

protocol SignupCoordinatorDelegate: class {
    func didCancel()
    func didSucceed()
}

class SignupCoordinator {
    
    weak var delegate: SignupCoordinatorDelegate?
    
    let rootViewController: UIViewController
    
    let usernameInteractor = UsernameInteractor()
    let usernamePresenter = UsernamePresenter()
    
    let errorPresenter = ErrorPresenter()
    
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
    
    func viewReady(completion: @escaping (UsernameViewData) -> Void) {
        let viewData = usernamePresenter.prepareDefault()
        completion(viewData)
    }
    
    func didChangeUsername(to text: String, completion: @escaping (UsernameViewData) -> Void) {
        usernameInteractor.udpateUsername(text: text) { validateStatus in
            let viewData = usernamePresenter.prepare(status: validateStatus)
            completion(viewData)
        }
    }
    
    func didTapNext(with text: String, completion: @escaping (UsernameViewData) -> Void) {
        guard let waitingViewController = loadViewController(named: "waiting") as? WaitingViewController else { return }
        progress(to: waitingViewController)

        usernameInteractor.submitUsername(text: text) { [weak self] submitStatus in
            guard let `self` = self else { return }
            switch submitStatus {
            case .success:
                self.success()
            case let .error(error):
                self.error(error)
            }
        }
    }
    
    func success() {
        guard let completeViewController = loadViewController(named: "complete") as? CompleteViewController else { return }
        completeViewController.delegate = self
        progress(to: completeViewController)
    }
    
    func error(_ error: UsernameInteractor.Error) {
        guard let errorViewController = loadViewController(named: "error") as? ErrorViewController else { return }
        errorViewController.message = errorPresenter.prepare(error: error)
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
