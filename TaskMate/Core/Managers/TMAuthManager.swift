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
    
    @Published var currentUser: User?
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var photoURL: URL?
    
    
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
                guard error == nil, let user = result?.user else {
                    completion(error)
                    return
                }
                self.currentUser = user
                self.displayName = user.displayName ?? "Unknown"
                self.email = user.email ?? "No Email"
                self.photoURL = user.photoURL
                
                TMDatabaseManager.shared.createInitialUserListIfNeeded(displayName: self.displayName)
                
                print("Sign in with google successfully")
            }
        }
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.displayName = ""
            self.photoURL = nil
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }
}

