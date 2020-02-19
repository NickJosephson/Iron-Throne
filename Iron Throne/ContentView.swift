//
//  ContentView.swift
//  Iron Throne
//
//  Created by Nicholas Josephson on 2020-02-18.
//  Copyright © 2020 Throne. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var login = LoginManager.shared
    @State private var scheme = "https"
    @State private var host = "api-dev.findmythrone.com"
    @State private var path = "/washrooms/"
    @State private var query = ""
    @State private var output = ""
    private var loginController = LoginUIViewController()
    
    var body: some View {
        VStack() {
            Form {
                HStack {
                    TextField("Scheme", text: $scheme).frame(maxWidth: 50)
                    TextField("Host", text: $host)
                }
                TextField("Path", text: $path)
                TextField("Query", text: $query)
                HStack {
                    TextField("Token", text: $login.accessToken)
                    Button(action: {
                        self.loginController.startLogin()
                    }, label: { Text("Login") })
                }
                HStack {
                    Button(action: {
                        self.output = "Fetching..."

                        var urlComponent = URLComponents()
                        urlComponent.scheme = "https"
                        urlComponent.host = self.host
                        urlComponent.path = self.path
                        urlComponent.query = self.query
                        
                        if let url = urlComponent.url {
                            print(url)
                            fetch(url: url) { data in
                                DispatchQueue.main.async {
                                    self.output = String(data: data, encoding: .utf8)!
                                }
                            }
                        } else {
                            self.output = "Request not send: Invalid URL"
                        }
                    }, label: { Text("GET") })
                    Button(action: {}, label: { Text("POST") }).disabled(true)
                    Button(action: {}, label: { Text("DELETE") }).disabled(true)
                }
            }
            LoginView(controller: loginController).frame(width: 0, height: 1)
            GroupBox(label: Text("Result")) {
                VStack {
                    HStack() {
                        Text(self.output)
                        .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
