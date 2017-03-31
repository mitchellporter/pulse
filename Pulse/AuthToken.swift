//
//  AuthToken.swift


import Foundation
import SwiftyJSON

public struct AuthToken {
    static var sharedKeychain: KeychainType = PulseKeychain()
    var keychain: KeychainType
    
    public init() {
        keychain = AuthToken.sharedKeychain
    }
    
    public var isPresent: Bool { // Check if user info is stored or not
        get { return keychain.authToken != nil ? true : false }
    }
    
    public var tokenWithBearer: String? {
        get {
            if let token = keychain.authToken {
                return "Bearer \(token)"
            }
            return nil
        }
    }
    
    public var token: String? {
        get { return keychain.authToken }
        set { keychain.authToken = newValue }
    }
    
    public var refreshToken: String? {
        get { return keychain.refreshAuthToken }
        set { keychain.refreshAuthToken = newValue }
    }
    
    public var userId: String? {
        get { return keychain.userId }
        set { keychain.userId = newValue }
    }
    
    public var name: String? {
        get { return keychain.name }
        set { keychain.name = newValue }
    }
    
    public var email: String? {
        get { return keychain.email }
        set { keychain.email = newValue }
    }
    
    public var position: String? {
        get { return keychain.position }
        set { keychain.position = newValue }
    }
    
    public static func storeToken(data: Data) {
        
        let json = JSON(data: data)
        
        print(json["user"]["_id"].stringValue)
        print(json["user"]["name"].stringValue)
        print(json["user"]["email"].stringValue)
        print(json["user"]["position"].stringValue)
        print(json["token"].string)
        
        var authToken = AuthToken()
        authToken.userId = json["user"]["_id"].stringValue
        authToken.name = json["user"]["name"].stringValue
        authToken.email = json["user"]["email"].stringValue
        authToken.position = json["user"]["position"].stringValue
//        token.password = ?? //TODO: password
        if let token = json["token"].string {
            authToken.token = token
        }
        
        print(authToken.token)
        print(authToken.userId)
        
    }
    
    static func reset() {
        var keychain = sharedKeychain
        keychain.userId = nil
        keychain.authToken = nil
        keychain.refreshAuthToken = nil
        keychain.authTokenType = nil
        keychain.name = nil
        keychain.email = nil
        keychain.position = nil
    }
}
