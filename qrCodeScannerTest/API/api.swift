//
//  api.swift
//  qrCodeScannerTest
//
//  Created by Matthew Wolfe on 2019-12-18.
//  Copyright © 2019 Matthew Wolfe. All rights reserved.
//

import Foundation

let prefix = "http://"

let ip = "192.168.2.13"

let portAppendix = ":8000"

let apiAppendix = "/api/"

func getBaseURL() -> String {
    
    let baseURL = prefix + ip + portAppendix + apiAppendix
    return baseURL
    
}

// Get's the auth token and logs in the user.
func apiLogin(username: String, password: String, completion:@escaping (_ result: Any, _ error: Error?) -> Void) {
    
    let session = URLSession(configuration: .default)
    let url = getBaseURL() + "obtain-token/"
    
    var request: URLRequest = URLRequest(url: URL(string: url)!)
    request.httpMethod = "POST"
    request.timeoutInterval = 30
    
    let data = [
        "username": username,
        "password": password
    ]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        request.httpBody = jsonData
    } catch {
        print(error.localizedDescription)
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    
    let task = session.dataTask(with: request) { (data, response, error) in
        
        guard let response = response as? HTTPURLResponse else { return }
        guard let data = data else { return }
            
        switch response.statusCode {
                
        case 200: // OK
            do {
                let getResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                completion(getResponse, error)
            } catch {
                completion([
                    "token": nil,
                    "error": "Unable to parse reponse."], error)
            }
            
        case 400: // Bad Request. Probably invalid login credentials. Treat it like such.
            completion([
                "token": nil,
                "error": "Invalid login credentials."], error)
        case 500: // Internal Server Error
            completion([
                "token": nil,
                "error": "500 Internal Server Error."], error)
        default:
            completion([
                "token": nil,
                "error": "An Unknown Error occurred."], error)
        }
        
    }
    
    task.resume()
    
}

// Calls the payment code on the backend.
func apiPay(url: String, completion:@escaping (_ result: Any, _ error: Error?) -> Void) {
    
    let session = URLSession(configuration: .default)
    
    var request: URLRequest = URLRequest(url: URL(string: url)!)
    request.httpMethod = "GET"
    request.timeoutInterval = 30
    
    guard let userToken = getToken() else { return }
    let token = "Token \(userToken)"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(token, forHTTPHeaderField: "Authorization")
    
    let task = session.dataTask(with: request) { (data, response, error) in
        
        guard let response = response as? HTTPURLResponse else { return }
        guard let data = data else { return }
        
        switch response.statusCode {
                
        case 200: // OK
            do {
                let getResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                completion(getResponse, error)
            } catch {
                completion([
                    "message": nil,
                    "error": "Unable to parse reponse."], error)
            }
            
        case 400: // Bad Request. Probably invalid login credentials. Treat it like such.
            completion([
                "message": nil,
                "error": "Invalid login credentials."], error)
        case 500: // Internal Server Error
            completion([
                "message": nil,
                "error": "500 Internal Server Error."], error)
        default:
            completion([
                "message": nil,
                "error": "An Unknown Error occurred."], error)
        }
        
    }
    
    task.resume()
    
}
