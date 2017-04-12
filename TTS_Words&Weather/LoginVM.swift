//
//  LoginVM.swift
//  TTS_Words&Weather
//
//  Created by Trevonte Dixon on 3/27/17.
//  Copyright © 2017 1umbrella. All rights reserved.
//

import Foundation

struct LoginVM {
    
    static func createAccount(userId: String, password: String) -> Bool {
        let defaults = UserDefaults.standard
        defaults.set(userId, forKey: Constants.userNameKey)
        KeychainService.savePassword(token: password)
        return true
    }
    
    static func loginVerification(userId: String, password: String) -> Bool {
            print("🔹 loginVerification, userId = \(userId), password = \(password)")
        
        let defaults = UserDefaults.standard
        guard let savedUserName = defaults.object(forKey: Constants.userNameKey) as? String, let savedPassword = KeychainService.loadPassword() else {
            print("🔻 viewDidLoad, no username found")
            return false
        }
        
        if savedUserName == userId && savedPassword == password {
            print("🔹 Success! you have successfully logged in")
            return true
        } else {
            print("Incorrect username and password")
            return false
        }
    }
}
