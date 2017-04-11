import Foundation

class UsernameInteractor {
    
    enum Error: Swift.Error {
        case network
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
    
    func udpateUsername(text: String, completion: (ValidateStatus) -> Void) {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.completeSubmit(text: text, completion: completion)
        }
    }
    
    private func completeSubmit(text: String, completion: (SubmitStatus) -> Void) {
        if 0 == arc4random() % 2 {
            completion(.success)
        } else {
            let error = UsernameInteractor.Error.network
            completion(.error(error))
        }
    }
}
