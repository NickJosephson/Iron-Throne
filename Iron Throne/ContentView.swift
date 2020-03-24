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
    @State private var requestInfo = RequestInfo()
    @State private var output = ""
    private var loginController = LoginUIViewController()
    
    var body: some View {
        VStack() {
            Form {
                HStack {
                    TextField("Scheme", text: $requestInfo.scheme).frame(maxWidth: 50)
                    TextField("Host", text: $requestInfo.host)
                    TextField("Port", text: $requestInfo.port).frame(maxWidth: 50)
                }
                TextField("Path", text: $requestInfo.path)
                TextField("Query", text: $requestInfo.query)
                HStack {
                    TextField("Token", text: $login.accessToken)
                    Button(action: { self.loginController.startLogin() }, label: { Text("Login") })
                }
                TextField("Body", text: $requestInfo.body)
                HStack {
                    Button(action: { self.performRequest(method: "GET") }, label: { Text("GET") })
                    Button(action: { self.performRequest(method: "POST") }, label: { Text("POST") })
                    Button(action: { self.performRequest(method: "PUT") }, label: { Text("PUT") })
                    Button(action: { self.performRequest(method: "DELETE") }, label: { Text("DELETE") })
                    Spacer()
                    Button(
                        action: {
                            let pasteBoard = NSPasteboard.general
                            pasteBoard.clearContents()
                            pasteBoard.writeObjects([self.output as NSString])
                        },
                        label: { Text("Copy") }
                    )
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
        .touchBar(
            TouchBar {
                Button(action: { self.performRequest(method: "GET") }, label: { Text("GET") })
                Button(action: { self.performRequest(method: "POST") }, label: { Text("POST") })
                Button(action: { self.performRequest(method: "PUT") }, label: { Text("PUT") })
                Button(action: { self.performRequest(method: "DELETE") }, label: { Text("DELETE") })
            }
        )
    }
    
    func performRequest(method: String) {
        self.output = "Performing Request..."
        if let request = self.requestInfo.formRequest(method: method) {
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

struct RequestInfo {
    var scheme = "https"
    var host = "api-dev.findmythrone.com"
    var port = ""
    var path = "/washrooms"
    var query = ""
    var body = ""
    
    func formRequest(method: String) -> URLRequest? {
        var request: URLRequest? = nil
        
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = path
        urlComponent.query = query
        if let portNumber = Int(port), port != "" {
            urlComponent.port = portNumber
        }
        
        if let url = urlComponent.url {
            request = URLRequest(url: url)
            request!.httpBody = body.data(using: .utf8)
            request!.httpMethod = method
            request!.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
}
