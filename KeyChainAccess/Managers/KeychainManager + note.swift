//
//  KeychainManager + notes.swift
//  KeyChainAccess
//
//  Created by Gokhan Mutlu on 20.07.2021.
//

import Foundation


import Foundation
import Security


protocol KeychainNoteAdapter{
    func addNote(note:Note, completion: @escaping (Result<String, KeychainError>) -> Void)
    func fetchNotes(completion: @escaping (Result<String, KeychainError>) -> Void)
    func updateNote(note:Note, completion: @escaping (Result<String, KeychainError>) -> Void)
    func deleteNote(uuid:String, completion: @escaping (Result<String, KeychainError>) -> Void)
}


extension KeychainManager:KeychainNoteAdapter{
    
    func deleteNote(uuid: String, completion: @escaping (Result<String, KeychainError>) -> Void) {
        
        let query:[String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String:uuid
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            if let msg = SecCopyErrorMessageString(status, nil) as String?{
                completion(.failure(KeychainError.unhandledError(message: msg)))
            }
            return
        }
        
        completion(.success("Note deleted"))
    }
    
    func updateNote(note:Note, completion: @escaping (Result<String, KeychainError>) -> Void) {
        let query:[String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String:note.id
        ]
        
        let attrs:[String:Any] = [
            kSecValueData as String: note.body.data(using: .utf8)!]
        
        let status = SecItemUpdate(query as CFDictionary, attrs as CFDictionary)
        guard status == errSecSuccess else {
            if let msg = SecCopyErrorMessageString(status, nil) as String?{
                completion(.failure(KeychainError.unhandledError(message: msg)))
            }
            return
        }
        completion(.success("Note updated"))
    }
    
    func fetchNotes(completion: @escaping (Result<String, KeychainError>) -> Void) {
        var item:CFTypeRef?
        
        //package secret as a keychain item
        let query:[String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: "note",
            kSecReturnData as String: true,
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll
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
        guard let theItems = item as? [[String:Any]] else{
            completion(.failure(KeychainError.unhandledError(message: "Item does not containt notes as a dictionary")))
            item = nil
            return
        }
    
        let items = theItems.compactMap { dic -> Note? in
            guard let data = dic[kSecValueData as String] as? Data,
                  let noteStr = String(data: data, encoding: .utf8) else {
                    return nil
                  }
            return Note(id: dic[kSecAttrAccount as String] as! String, body: noteStr)
        }
        
        print(items)
        completion(.success("\(items.count) note is fetched! The note is:\n\(items.first?.body ?? "?")"))
        
        item = nil
    }
    
    
    func addNote(note:Note, completion: @escaping (Result<String, KeychainError>) -> Void) {
        let noteBody = note.body.data(using: .utf8)!
        
        //package secret as a keychain item
        let query:[String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: note.id,
            kSecValueData as String: noteBody,
            kSecAttrLabel as String: "note"
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            if let msg = SecCopyErrorMessageString(status, nil) as String?{
                completion(.failure(KeychainError.unhandledError(message: msg)))
            }
            return
        }
        
        completion(.success("Note added to Keychain"))
    }
    
    
}
