//
//  ServiceUtilities.swift
//  Throne
//
//  Created by Nicholas Josephson on 2020-01-30.
//  Copyright © 2020 Throne. All rights reserved.
//

import Foundation


/// Fetch Data at a given URL.
///
/// If an accessToken is set it will be used for authentication.
/// - Parameters:
///   - url: URL to send GET request to.
///   - completionHandler: Function to handle Data once received.
func fetch(url: URL, completionHandler: @escaping (Data) -> Void) {
    var request = URLRequest(url: url)

    if LoginManager.shared.accessToken != "" {
        request.addValue("Bearer \(LoginManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    }

    performRequest(with: request, completionHandler: completionHandler)
}

/// Perform a URLRequest with error handling.
/// - Parameters:
///   - request: URLRequest to perform.
///   - completionHandler: Function to handle Data once received.
func performRequest(with request: URLRequest, completionHandler: @escaping (Data) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Fetching error: \(error)")
            completionHandler("Fetching error: \(error)".data(using: .utf8)!)
            return
        }

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401 {
                print("Fetching error: Unauthorized, you may need to login again.")
                completionHandler("Fetching error: Unauthorized, you may need to login again.".data(using: .utf8)!)
                return 
            }
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Fetching error: Unexpected status code: \(String(describing: response))")
            completionHandler("Fetching error: Unexpected status code: \(String(describing: response))".data(using: .utf8)!)
            return
        }

        if let data = data {
            completionHandler(data)
        }
    }

    task.resume()
}
