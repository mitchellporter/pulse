//
//  NetworkingClient.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import Nuke

typealias PulseSuccessCompletion = (_ data: Data) -> Void
typealias PulseFailureCompletion = (_ error: Error, _ statusCode: Int?) -> Void

class NetworkingClient: NSObject {
    static var sharedClient = NetworkingClient()
    private (set) var session: URLSession
    
    private override init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        super.init()
    }
    
    func request(target: PulseAPI, success: @escaping PulseSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        let request = NSMutableURLRequest()
        request.allHTTPHeaderFields = target.headers
        request.url = target.url!
        request.httpMethod = target.method.rawValue
        
        if target.method == .get && target.parameters != nil {
            
            let URLComponents = NSURLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            let percentEncodedQuery = (URLComponents!.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters: target.parameters! as [String : AnyObject])
            URLComponents!.percentEncodedQuery = percentEncodedQuery
            request.url = URLComponents!.url
        } else {
            
            // Check for body
            if let parameters = target.parameters {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch let error as NSError {
                    OperationQueue.main.addOperation({
                        failure(error, nil) // TODO: Handle status code
                    })
                    return
                }
            }
        }
        
        self.session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                self.handleNetworkFailure(error: error, success: success, failure: failure)
            } else {
                // Create a response config
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    switch statusCode {
                    case 200...299, 300...399:
                        if let data = data {
                            OperationQueue.main.addOperation({
                                success(data)
                            })
                        }
                        // TODO: Handle 401 authentication error
                    // attemptAuthentication((target, success: success, failure: failure), uuid: uuid)
                    default:
                        self.handleServerFailure(data: data, statusCode: statusCode, success: success, failure: failure)
                    }
                }
            }
            }.resume()
    }
    
    // TODO: Generate errors
    private func handleServerFailure(data: Data?, statusCode: Int, success: PulseSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        // Attempts to generate userInfo aka error message for NSError if it's a statusCode we actually care about
        //        let error = self.generateServerError(data!, statusCode: statusCode)
        OperationQueue.main.addOperation({
            //            failure(error: error, statusCode: statusCode)
        })
    }
    
    // Error from NSURLSession
    private func handleNetworkFailure(error: Error, success: PulseSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        OperationQueue.main.addOperation({
            failure(error, nil)
        })
    }
}

extension NetworkingClient {
    func query(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(key: key, value)
        }
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
    
    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(key: "\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents(key: "\(key)[]", value)
            }
        } else {
            components.append((escape(string: key), escape(string: "\(value)")))
        }
        
        return components
    }
    
    func escape(string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        
        escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        return escaped
    }
}
