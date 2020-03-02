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
    @State private var path = "/washrooms"
    @State private var port = ""
    @State private var query = ""
    @State private var requestBody = ""
    @State private var output = ""
    private var loginController = LoginUIViewController()
    
    var body: some View {
        VStack() {
            Form {
                HStack {
                    TextField("Scheme", text: $scheme).frame(maxWidth: 50)
                    TextField("Host", text: $host)
                    TextField("Port", text: $port).frame(maxWidth: 50)
                }
                TextField("Path", text: $path)
                TextField("Query", text: $query)
                HStack {
                    TextField("Token", text: $login.accessToken)
                    Button(action: {
                        self.loginController.startLogin()
                    }, label: { Text("Login") })
                }
                TextField("Body", text: $requestBody)
                HStack {
                    Button(action: {
                        self.output = "Fetching..."

                        var urlComponent = URLComponents()
                        urlComponent.scheme = self.scheme
                        urlComponent.host = self.host
                        urlComponent.path = self.path
                        urlComponent.query = self.query
                        if let portNumber = Int(self.port), self.port != "" {
                            urlComponent.port = portNumber
                        }
                        
                        if let url = urlComponent.url {
                            print(url)
                            fetch(url: url) { data in
                                DispatchQueue.main.async {
                                    if let prettyJSON = data.prettyPrintedJSONString {
                                        self.output = prettyJSON as String
                                    } else {
                                        self.output = String(data: data, encoding: .utf8)!
                                    }
                                }
                            }
                        } else {
                            self.output = "Request not send: Invalid URL"
                        }
                    }, label: { Text("GET") })
                    Button(action: {
                        self.output = "Sending..."

                        var urlComponent = URLComponents()
                        urlComponent.scheme = self.scheme
                        urlComponent.host = self.host
                        urlComponent.path = self.path
                        urlComponent.query = self.query
                        if let portNumber = Int(self.port), self.port != "" {
                            urlComponent.port = portNumber
                        }
                        
                        if let url = urlComponent.url {
                            print(url)
                            var request = URLRequest(url: url)
                            request.httpBody = self.requestBody.data(using: .utf8)
                            request.httpMethod = "POST"
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            
                            print(self.requestBody)
                            
                            performRequestWithAuthentication(with: request) { data in
                                DispatchQueue.main.async {
                                    if let prettyJSON = data.prettyPrintedJSONString {
                                        self.output = prettyJSON as String
                                    } else {
                                        self.output = String(data: data, encoding: .utf8)!
                                    }
                                }
                            }
                        } else {
                            self.output = "Request not send: Invalid URL"
                        }
                    }, label: { Text("POST") })
                    Button(action: {
                        self.output = "Sending..."

                        var urlComponent = URLComponents()
                        urlComponent.scheme = self.scheme
                        urlComponent.host = self.host
                        urlComponent.path = self.path
                        urlComponent.query = self.query
                        if let portNumber = Int(self.port), self.port != "" {
                            urlComponent.port = portNumber
                        }
                        
                        if let url = urlComponent.url {
                            print(url)
                            var request = URLRequest(url: url)
                            request.httpBody = self.requestBody.data(using: .utf8)
                            request.httpMethod = "PUT"
                            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                            performRequestWithAuthentication(with: request) { data in
                                DispatchQueue.main.async {
                                    if let prettyJSON = data.prettyPrintedJSONString {
                                        self.output = prettyJSON as String
                                    } else {
                                        self.output = String(data: data, encoding: .utf8)!
                                    }
                                }
                            }
                        } else {
                            self.output = "Request not send: Invalid URL"
                        }
                    }, label: { Text("PUT") })
                    Button(action: {
                        self.output = "Sending..."

                        var urlComponent = URLComponents()
                        urlComponent.scheme = self.scheme
                        urlComponent.host = self.host
                        urlComponent.path = self.path
                        urlComponent.query = self.query
                        if let portNumber = Int(self.port), self.port != "" {
                            urlComponent.port = portNumber
                        }
                        
                        if let url = urlComponent.url {
                            print(url)
                            var request = URLRequest(url: url)
                            request.httpBody = self.requestBody.data(using: .utf8)
                            request.httpMethod = "DELETE"
                            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                            performRequestWithAuthentication(with: request) { data in
                                DispatchQueue.main.async {
                                    if let prettyJSON = data.prettyPrintedJSONString {
                                        self.output = prettyJSON as String
                                    } else {
                                        self.output = String(data: data, encoding: .utf8)!
                                    }
                                }
                            }
                        } else {
                            self.output = "Request not send: Invalid URL"
                        }
                    }, label: { Text("DELETE") })
                }
            }

            LoginView(controller: loginController).frame(width: 0, height: 1)
            GroupBox(label: Text("Result")) {
                ScrollView {
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

extension Data {
    
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
        let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
        let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}
