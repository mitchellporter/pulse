
//  PulseKeychain.swift

import Foundation
import KeychainAccess

public protocol KeychainType {
    var authToken: String? { get set }
    var authTokenType: String? { get set }
    var refreshAuthToken: String? { get set }
    var pushToken: Data? { get set }
    var userId: String? { get set }
    var name: String? { get set }
    var email: String? { get set }
    var position: String? { get set }
    var teamId: String? { get set }
}

private let PushToken = "PulsePushToken"
private let AuthTokenKey = "PulseAuthToken"
private let AuthTokenRefresh = "PulseAuthTokenRefresh"
private let AuthTokenType = "PulseAuthTokenType"
private let AuthTokenAuthenticated = "PulseAuthTokenAuthenticated"
private let AuthUserId = "PulseAuthUserId"
private let AuthName = "PulseAuthName"
private let AuthEmail = "PulseAuthEmail"
private let AuthPosition = "PulseAuthPosition"
private let AuthTeamId = "PulseAuthTeamId"


public struct PulseKeychain: KeychainType {
    
    public var keychain: Keychain
    
    public init() {
            self.keychain = Keychain(service: "com.mentorventures.ellroi") // TODO: Un-hardcode this
    }
    
    public var pushToken: Data? {
        get { return keychain[data: PushToken] }
        set { keychain[data: PushToken] = newValue }
    }
    
    public var authToken: String? {
        get { return keychain[AuthTokenKey] }
        set { keychain[AuthTokenKey] = newValue }
    }
    
    public var refreshAuthToken: String? {
        get { return keychain[AuthTokenRefresh] }
        set { keychain[AuthTokenRefresh] = newValue }
    }
    
    public var authTokenType: String? {
        get { return keychain[AuthTokenType] }
        set { keychain[AuthTokenType] = newValue }
    }
    
    public var userId: String? {
        get { return keychain[AuthUserId] }
        set { keychain[AuthUserId] = newValue }
    }
    
    public var name: String? {
        get { return keychain[AuthName] }
        set { keychain[AuthName] = newValue }
    }
    
    public var email: String? {
        get { return keychain[AuthEmail] }
        set { keychain[AuthEmail] = newValue }
    }
    
    public var position: String? {
        get { return keychain[AuthPosition] }
        set { keychain[AuthPosition] = newValue }
    }
    
    public var teamId: String? {
        get { return keychain[AuthTeamId] }
        set { keychain[AuthTeamId] = newValue }
    }
}
