//
//  TMAuthManager.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 21/6/25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

final class TMAuthManager: NSObject, ObservableObject {
    static let shared = TMAuthManager()
    
    private override init() {
        
    }
    
    func signinWithGoogle(presenting: UIViewController, completion: @escaping(Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let signInVC = presenting
        signInVC.modalPresentationStyle = .fullScreen

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
            guard error == nil else {
                completion(error)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                print("Sign in with google successfully")
            }
        }

    }
}

