

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

protocol GoogleAuthServiceProtocol {
    func signInWithGoogle(with vc: UIViewController, completion: @escaping(Error?, User?) -> ())
    func checkIfUserLoggedIn(completion: @escaping(User?, Bool) -> ())
}

class GoogleAuthService: GoogleAuthServiceProtocol {
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func checkIfUserLoggedIn(completion: @escaping (User?, Bool) -> ()) {
        if let email = Auth.auth().currentUser?.email {
            userService.getUser(by: email) { user in
                completion(user, true)
            }
        } else {
            completion(nil, false)
        }
    }
    
    
    func signInWithGoogle(with vc: UIViewController, completion: @escaping (Error?, User?) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
            guard error == nil else { return }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { res, error in
                if let email = user.profile?.email, let name = user.profile?.name, let profileImageUrl = user.profile?.imageURL(withDimension: 200) {
                    self.userService.checkIfUserExists(email: email) { doesExist in
                        let urlString = profileImageUrl.absoluteString
                        let username = generateRandomUsername()
                        let uid = res?.user.uid
                        if !doesExist {
                            self.userService.createUser(name: name, email: email, username: username, profileUrl: urlString, uid: uid!) { error, user in
                                completion(error, user)
                            }
                            return
                        } else {
                            self.userService.getUser(by: email) { user in
                                completion(error, user)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
}
