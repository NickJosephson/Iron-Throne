//
//  LoginManager.swift
//  Throne
//
//  Created by Nicholas Josephson on 2020-02-01.
//  Copyright © 2020 Throne. All rights reserved.
//

import Foundation
import Combine

/// Manage the state of user authentication and credentials.
final class LoginManager: ObservableObject {
    static var shared = LoginManager() // Shared instance to use across application
    
    @Published var accessToken: String = ""
    
    func attemptLogin(with code: String) {
        AuthenticationEndpoint.fetchTokens(authorizedWith: code) { tokens in
            DispatchQueue.main.async {
                self.accessToken = tokens.accessToken
            }
        }
    }
}
