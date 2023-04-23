
import FirebaseAuth

public class AuthManager {
    static let shared = AuthManager()
    // MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void)
    {
        /**
                    - Check if username is availible, check if email is availibile, create account, insert account to database
         */
        DatabaseManager.shared.usernameAvailible(with: email, username: username) {
            canCreate in
            if canCreate{
                Auth.auth().createUser(withEmail: email, password: password) {
                    result, error in guard
                    error == nil, result != nil else{
                        completion(false)
                        return
                    }
                    //Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted{
                            completion(true)
                            return
                        }
                        else{
                            //failed
                            completion(false)
                            return
                        }
                    }
                }
            }
            else{
                //Either username or email doesnt exist
                completion(false)
            }
        }
        
    }
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping ((Bool) -> Void)){
        if let email = email{
            Auth.auth().signIn(withEmail: email, password: password) {
                authResult, error in guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username{
            print(username)
        }
    }
}
