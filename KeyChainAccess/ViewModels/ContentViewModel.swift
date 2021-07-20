//
//  ContentViewModel.swift
//  KeyChainAccess
//
//  Created by Gokhan Mutlu on 19.07.2021.
//

import Foundation
import Combine
import Security

class ContentViewModel:ObservableObject{
    @Published var message:String = "message"{
        didSet{
            print(message)
        }
    }
    
    #warning("Inject Keychain adapter!")
    //TODO: Inject Keychain adapter!
    
    func addPassword(){
        print("\(#function)")
        
        //prepare
        let userName = "gokhan"
        let password = "1234"
        
        KeychainManager().addPassword(userName: userName, password: password) { result in
            self.handleResult(result)
        }
    }
    
    func searchPassword(){
        print("\(#function)")
        //searchReturnsAttributes()
                
        let userName = "gokhan"
        KeychainManager().searchPassword(userName: userName){ result in
            self.handleResult(result)
        }
    }
    
   
   
    func updatePassword(){
        print("\(#function)")
        let userName = "gokhan"
        let newPassword = "1234_new"
        
        KeychainManager().updatePassword(userName: userName, newPassword: newPassword) { result in
            self.handleResult(result)
        }
      
    }
    
    func deletePassword(){
        print("\(#function)")
        let userName = "gokhan"
        KeychainManager().deletePassword(userName: userName) { result in
            self.handleResult(result)
        }
    }
}

extension ContentViewModel{
    
    func addNote(){
        print("\(#function)")
        
        let note = Note()
        KeychainManager().addNote(note: note, completion: { result in
            self.handleResult(result)
        })
    }
    
    func fetchNotes(){
        print("\(#function)")

        KeychainManager().fetchNotes{ result in
            self.handleResult(result)
        }
    }
    
    
    func updateNote(){
        print("\(#function)")
        
        var note = Note()
        note.body = note.body + " - updated"
        
        KeychainManager().updateNote(note: note) { result in
            self.handleResult(result)
        }
        
    }
    
    func deleteNote(){
        print("\(#function)")
        let note = Note()
        KeychainManager().deleteNote(uuid: note.id) { result in
            self.handleResult(result)
        }
    }
}


extension ContentViewModel{
    
    private func handleResult(_ result:Result<String, KeychainError>){
        var tmpMessage:String = ""
        
        switch result{
        case .failure(let error):
            if case KeychainError.unhandledError(let message) = error{
                tmpMessage = message
            }
        case .success(let msg):
            tmpMessage = msg
        }
        
        DispatchQueue.main.async {
            self.message = tmpMessage
        }
    }
    
    
    private func searchReturnsAttributes(){
        let userName = "gokhan"
        var item:CFTypeRef?
        
        //package secret as a keychain item
        let query:[String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            if let msg = SecCopyErrorMessageString(status, nil){
                message = msg as String
            }
            item = nil
            return
        }
        
        //handling search result
        guard let theItem = item as? [String:Any],
              let account = theItem[kSecAttrAccount as String] as? String,
              let pwData = theItem[kSecValueData as String] as? Data,
              let password = String(data: pwData, encoding: .utf8) else {
            message = "Password not found"
            return
        }
        item = nil
        message = "\(account)'s password is: \(password)"
    }
}
