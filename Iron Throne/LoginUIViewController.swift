//
//  LoginUIViewController.swift
//  Iron Throne
//
//  Created by Nicholas Josephson on 2020-02-18.
//  Copyright © 2020 Throne. All rights reserved.
//

import Cocoa
import AuthenticationServices

class LoginUIViewController: NSViewController, ASWebAuthenticationPresentationContextProviding {
    private var session: ASWebAuthenticationSession!

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
//    // ASWebAuthenticationPresentationContextProviding protocol method
//    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
//        return view.window!
//    }
    
    /// Present a webpage to login to Throne
    func startLogin() {
        startSession(at: AuthenticationEndpoint.loginAddress)
    }
    
    /// Present a webpage to signup to Throne
    func startSignup() {
        startSession(at: AuthenticationEndpoint.signupAddress)
    }

    /// Start a ASWebAuthenticationSession at the specified URL to login to Throne
    ///
    /// The authentication code that is returned by the session is used to initiate a login with the LoginManager
    private func startSession(at url: URL) {
        let scheme = "throne" // A redirect to "throne://" will exit the session
        
        if let currentSession = session {
            currentSession.cancel()
        }
        
        session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else {
                print("ASWebAuthenticationSession failed: \(error.debugDescription)")
                return
            }
            
            guard let queryItems = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems else {
                print("ASWebAuthenticationSession failed: No query items in callback URL.")
                return
            }
            
            guard let authenticationCode = queryItems.filter({ $0.name == "code" }).first?.value else {
                print("ASWebAuthenticationSession failed: No authentication code in callback URL.")
                return
            }
            
            DispatchQueue.main.async {
                LoginManager.shared.attemptLogin(with: authenticationCode)
            }
        }
        
        session.presentationContextProvider = self
        session.start()
    }
    
}

