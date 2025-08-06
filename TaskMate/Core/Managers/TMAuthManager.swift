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
import Combine


final class TMAuthManager: NSObject, ObservableObject {
    static let shared = TMAuthManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()

    private override init() {
        setupAuthListener()
    }
    
    private func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }

        isLoading = true

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }

                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    self?.errorMessage = "Failed to get Google ID token"
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
//    func signinWithGoogle(presenting: UIViewController, completion: @escaping(Error?) -> Void) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        
//        let signInVC = presenting
//        signInVC.modalPresentationStyle = .fullScreen
//        
//        isLoading = true
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                
//                
//            }
//            guard error == nil else {
//                completion(error)
//                return
//            }
//            
//            guard let user = result?.user,
//                  let idToken = user.idToken?.tokenString
//            else {
//                return
//            }
//            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                           accessToken: user.accessToken.tokenString)
//            
//            Auth.auth().signIn(with: credential) { result, error in
//                guard error == nil, let user = result?.user else {
//                    completion(error)
//                    return
//                }
//                self.currentUser = user
//                self.displayName = user.displayName ?? "Unknown"
//                self.email = user.email ?? "No Email"
//                self.photoURL = user.photoURL
//                
//                TMDatabaseManager.shared.createInitialUserListIfNeeded(displayName: self.displayName)
//                
//                print("Sign in with google successfully")
//            }
//        }
//        
//    }
//    
//    func signOut() {
//        do {
//            try Auth.auth().signOut()
//            self.currentUser = nil
//            self.displayName = ""
//            self.photoURL = nil
//        } catch {
//            print("Sign out failed: \(error.localizedDescription)")
//        }
//    }
}

