//
//  KeychainManager.swift
//  KeyChainAccess
//
//  Created by Gokhan Mutlu on 20.07.2021.
//

import Foundation
import Security

enum KeychainError: Error {
    case unhandledError(message:String)
}


protocol KeychainAdapter{
    func add(userName:String, password:String, completion: @escaping (Result<String, KeychainError>) -> Void)
    func search(userName:String, completion: @escaping (Result<String, KeychainError>) -> Void)
    func update(userName:String, newPassword:String, completion: @escaping (Result<String, KeychainError>) -> Void)
    func delete(userName:String, completion: @escaping (Result<String, KeychainError>) -> Void)
}

class KeychainManager:KeychainAdapter{
    
    func delete(userName: String, completion: @escaping (Result<String, KeychainError>) -> Void) {
        
        let query:[String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String:userName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            if let msg = SecCopyErrorMessageString(status, nil) as String?{
                completion(.failure(KeychainError.unhandledError(message: msg)))
            }
            return
        }
        
        completion(.success("Account deleted"))
    }
    
    func update(userName: String, newPassword:String, completion: @escaping (Result<String, KeychainError>) -> Void) {
        let query:[String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String:userName
        ]
        
        let attrs:[String:Any] = [
            kSecValueData as String: newPassword.data(using: .utf8)!]
        
        let status = SecItemUpdate(query as CFDictionary, attrs as CFDictionary)
        guard status == errSecSuccess else {
            if let msg = SecCopyErrorMessageString(status, nil) as String?{
                completion(.failure(KeychainError.unhandledError(message: msg)))
            }
            return
        }
        completion(.success("Password updated"))
    }
    
    func search(userName: String, completion: @escaping (Result<String, KeychainError>) -> Void) {
        var item:CFTypeRef?
        
        //package secret as a keychain item
        let query:[String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecReturnData as String: true
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            if let msg = SecCopyErrorMessageString(status, nil) as String?{
                completion(.failure(KeychainError.unhandledError(message: msg)))
            }
            item = nil
            return
        }
        
        //handling search result
        guard let theItem = item as? Data,
              let password = String(data: theItem, encoding: .utf8) else {
            completion(.failure(KeychainError.unhandledError(message: "Item nil, or password is not valid data")))
            item = nil
            return
        }

        completion(.success("Password is: \(password)"))
        item = nil
    }
    
    
    func add(userName:String, password:String, completion: @escaping (Result<String, KeychainError>) -> Void) {
        let passwordData = password.data(using: .utf8)!

        //package secret as a keychain item
        let query:[String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            if let msg = SecCopyErrorMessageString(status, nil) as String?{
                completion(.failure(KeychainError.unhandledError(message: msg)))
            }
            return
        }
        
        completion(.success("Password added to Keychain"))
    }
    
    
}


