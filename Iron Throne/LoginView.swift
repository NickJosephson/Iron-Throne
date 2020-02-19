//
//  LoginView.swift
//  Throne
//
//  Created by Nicholas Josephson on 2020-01-31.
//  Copyright © 2020 Throne. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import Cocoa

/// SwiftUI container for LoginViewController
struct LoginView: NSViewRepresentable {
    var controller: LoginUIViewController
    
    func makeNSView(context: Context) -> NSView {
        return controller.view
    }

    func updateNSView(_ uiView: NSView, context: Context) {
    }
}

