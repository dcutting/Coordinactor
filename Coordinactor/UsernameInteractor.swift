enum UsernameInvalidReason {
    case tooShort(minimum: Int)
    case disallowedCharacters([Character])
}

enum UsernameValidationStatus {
    case valid
    case invalid([UsernameInvalidReason])
}

class UsernameInteractor {
    
    let minimumLength = 3
    let disallowedCharacters = "!@#$%".characters
    
    func udpateUsername(text: String, completion: (UsernameValidationStatus) -> Void) {
        let status = validate(username: text)
        completion(status)
    }
    
    func validate(username: String) -> UsernameValidationStatus {
        var reasons = [UsernameInvalidReason]()
        if username.characters.count < minimumLength {
            reasons.append(.tooShort(minimum: minimumLength))
        }
        var containedDisallowedCharacters = [Character]()
        for char in disallowedCharacters {
            if username.characters.contains(char) {
                containedDisallowedCharacters.append(char)
            }
        }
        reasons.append(.disallowedCharacters(containedDisallowedCharacters))
        return reasons.isEmpty ? .valid : .invalid(reasons)
    }
}
