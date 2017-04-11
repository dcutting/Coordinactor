class UsernameInteractor {
    
    enum Error: Swift.Error {
        case service(Swift.Error)
    }
    
    enum InvalidReason {
        case tooShort(minimum: Int)
        case disallowedCharacters([Character])
    }
    
    enum ValidateStatus {
        case valid(String)
        case invalid(String, [InvalidReason])
    }
    
    enum SubmitStatus {
        case success
        case error(Error)
    }
    
    let minimumLength = 3
    let disallowedCharacters = "!@# $%".characters
    
    let signupService: SignupService
    
    init(signupService: SignupService) {
        self.signupService = signupService
    }
    
    func updateUsername(text: String, completion: (ValidateStatus) -> Void) {
        let status = validate(username: text)
        completion(status)
    }
    
    private func validate(username: String) -> ValidateStatus {
        var reasons = [InvalidReason]()
        if username.characters.count < minimumLength {
            reasons.append(.tooShort(minimum: minimumLength))
        }
        var containedDisallowedCharacters = [Character]()
        for char in disallowedCharacters {
            if username.characters.contains(char) {
                containedDisallowedCharacters.append(char)
            }
        }
        if !containedDisallowedCharacters.isEmpty {
            reasons.append(.disallowedCharacters(containedDisallowedCharacters))
        }
        return reasons.isEmpty ? .valid(username) : .invalid(username, reasons)
    }
    
    func submitUsername(text: String, completion: @escaping (SubmitStatus) -> Void) {
        signupService.signup(username: text) { status in
            switch status {
            case .success:
                completion(.success)
            case let .error(error):
                let error = UsernameInteractor.Error.service(error)
                completion(.error(error))
            }
        }
    }
}
