//
//  DatabaseManager.swift
//  ARBrush
//
//  Created by Andrew Wang on 4/22/23.
//  Copyright © 2023 Laan Labs. All rights reserved.
//

import FirebaseDatabase

public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    ///Check if user and email is availible
    /// - Parameters
    ///     - email: string
    ///         - username: strring
    public func usernameAvailible(with email: String, username: String, completion: (Bool)-> Void){
        
        completion(true)
    }
    
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool)->Void){
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _ in
            if error == nil{
                //succeeded
                completion(true)
                return
            }
            else{
                //failed
                completion(false)
                return
            }
        }
    }
    //MARK: - PRIVATE
    
    
}
