import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import GoogleSignIn


class GoogleAuthService: GoogleAuthServiceProtocol {
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func checkIfUserLoggedIn(completion: @escaping (UserViewModel?, Bool) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            completion(nil, false)
            return
        }
        
        userService.getUser(by: email) { user in
            completion(user, true)
        }
    }
    
    func signInWithGoogle(with vc: UIViewController, completion: @escaping (Error?, UserViewModel?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(nil, nil)
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(nil, nil)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(error, nil)
                    return
                }
                
                guard let email = user.profile?.email, let name = user.profile?.name, let profileImageUrl = user.profile?.imageURL(withDimension: 200) else {
                    completion(nil, nil)
                    return
                }
                
                let urlString = profileImageUrl.absoluteString
                let username = generateRandomUsername()
                let uid = authResult?.user.uid
                
                self.userService.checkIfUserExists(email: email) { doesExist in
                    if doesExist {
                        self.userService.getUser(by: email) { user in
                            completion(nil, user)
                        }
                    } else {
                        self.userService.createUser(name: name, email: email, username: username, profileUrl: urlString, uid: uid ?? "") { error, user in
                            completion(error, user)
                        }
                    }
                }
            }
        }
    }
}


