import UIKit

protocol SignupCoordinatorDelegate: class {
    func didCancel()
    func didSucceed()
}

class SignupCoordinator {
    
    weak var delegate: SignupCoordinatorDelegate?
    
    let rootViewController: UIViewController
    var navigationController: UINavigationController?
    
    var usernameInteractor: UsernameInteractor?
    var usernamePresenter: UsernamePresenter?
    var usernameViewController: UsernameViewController?
    
    let errorPresenter = ErrorPresenter()
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        guard let signupViewController = loadViewController(named: "signup") as? SignupViewController else { return }
        signupViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: signupViewController)
        rootViewController.present(navigationController, animated: true)
        
        self.navigationController = navigationController
    }
    
    func loadViewController(named name: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name)
    }
    
    func progress(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
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
        makeUsernameModule()
        guard let usernameViewController = usernameViewController else { return }
        progress(to: usernameViewController)
    }
    
    func makeUsernameModule() {
        let signupService = MockSignupService()
        usernameInteractor = UsernameInteractor(signupService: signupService)
        usernamePresenter = UsernamePresenter()

        guard let usernameViewController = loadViewController(named: "username") as? UsernameViewController else { return }
        usernameViewController.delegate = self
        self.usernameViewController = usernameViewController
    }
}

extension SignupCoordinator: UsernameViewControllerDelegate {
    
    func viewReady() {
        let viewData = usernamePresenter?.prepareDefault()
        usernameViewController?.viewData = viewData
    }
    
    func didChangeUsername(to text: String) {
        usernameInteractor?.updateUsername(text: text) { validateStatus in
            let viewData = usernamePresenter?.prepare(status: validateStatus)
            usernameViewController?.viewData = viewData
        }
    }
    
    func didTapNext(with text: String) {
        showLoading()
        usernameInteractor?.submitUsername(text: text) { [weak self] submitStatus in
            guard let `self` = self else { return }
            self.hideLoading()
            self.disposeUsernameModule()
            switch submitStatus {
            case .success:
                self.success()
            case let .error(error):
                self.error(error)
            }
        }
    }
    
    private func disposeUsernameModule() {
        usernameViewController = nil
        usernameInteractor = nil
        usernamePresenter = nil
    }
    
    private func showLoading() {
        let alert = UIAlertController(title: "Submitting...", message: nil, preferredStyle: .alert)
        navigationController?.present(alert, animated: true)
    }
    
    private func hideLoading() {
        navigationController?.dismiss(animated: true)
    }
    
    func success() {
        guard let completeViewController = loadViewController(named: "complete") as? CompleteViewController else { return }
        completeViewController.navigationItem.setHidesBackButton(true, animated: true)
        completeViewController.delegate = self
        progress(to: completeViewController)
    }
    
    func error(_ error: UsernameInteractor.Error) {
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
