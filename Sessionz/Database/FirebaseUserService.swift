//
//  FirebaseUserService.swift
//  Sessionz
//
//  Created by C4Q on 5/21/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import Foundation
import Firebase
import FirebaseDatabase


enum UserProfileStatus: Error {
    case failedToAddToDatabase
    case didAddToDatabase
    case failedToLoadUSer
    case didLoadUser
    
}

//This service is responsible for handling any changes in regards to the User Profile Object.
class UserProfileService {
    
    init(){ //not private because class is needed to add user profile object to firbase when the user is created
        //root reference
        let dbRef = Database.database().reference()
        //child reference
        usersRef = dbRef.child("users")
    }
    
    weak public var delegate: UserProfileDelegate!
    static let manager = UserProfileService()
    public var usersRef: DatabaseReference!
    var allUsers = [UserProfile]()
    
    
    //MARK: Adds user to database
    func addUserToFirebaseDatabase(userUID: String, displayName: String,  profileImageURL: String, flags: Int, isBanned: Bool){
        let userNameDatabaseReference = usersRef.child(userUID)
        let user: UserProfile
        user =  UserProfile.init(withUserID: userUID, displayName: displayName, team: nil, image: profileImageURL, flags: flags, isBanned: false, console: nil, onlineProfile: nil); userNameDatabaseReference.setValue(user.convertToJSON()) { (error, _) in
            if let error = error {
                print("User not added with error: \(error)")
            } else {
                print("User added to firebase with userUID: \(userUID)")
            }
        }
    }
    
    
    //MARK: get user for injection into public and private user profiles
    public func getUser(fromUserUID userUID: String, completion: @escaping (_ currentUser: UserProfile) -> Void){
        usersRef.child(userUID)
        usersRef.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let snapshots = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                print("couldn't get user snapshots")
                return
            }
            var currentUsers: [UserProfile] = []
            for snapshot in snapshots {
                
                let currentUser = UserProfile.init(withSnapshot: (snapshot.value as? NSDictionary)!)
                currentUsers.append(currentUser)
                
//                if let json = snapshot.value {
//                    do{
//                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
//                        let currentUser = try JSONDecoder().decode(UserProfile.self, from: jsonData)
//                        currentUsers.append(currentUser)
//                    }catch{
//                        print("Unable to parse currentUser")
//                    }
//                }
            }
            if let index = currentUsers.index(where: { (userProfile) -> Bool in
                return userProfile.userID == userUID
            }) {
                let currentUser = currentUsers[index]
                completion(currentUser)
            }
        }
    }
    
    public func getAllUsers(completion: @escaping (_ users: [UserProfile]) -> Void) {
        usersRef.observe(.value) { (dataSnapshot) in
            var users: [UserProfile] = []
            guard let userSnapshots = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for userSnapshot in userSnapshots {
                guard let userObject = userSnapshot.value as? [String:Any] else {return}
               
               
                guard let displayName = userObject["displayName"] as? String,
                let flags = userObject["flags"] as? Int,
                let isBanned = userObject["isBanned"] as? Bool,
                let userID = userObject["userID"] as? String else { print("error getting users");return}
                
                let character = userObject["character"] as? String
                let console = userObject["console"] as? String
                let image = userObject["image"] as? String
                 let onlineTag = userObject["onlineTag"] as? String
                let thisUser = UserProfile.init(withUserID: userID, displayName: displayName, team: character, image: image, flags: flags, isBanned: isBanned, console: console, onlineProfile: onlineTag)
                users.append(thisUser)
            }
            UserProfileService.manager.allUsers = users
            completion(users)
        }
    }

    
    /////////////Functions to use in version 2
    
    
    //MARK: Gets display name from userID
    public func getName(from userUID: String, completion: @escaping (String) -> Void){
        let child = usersRef.child(userUID)
        child.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let json = dataSnapshot.value {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let user = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                    completion(user.displayName)
                } catch {
                    print("Failed to parse user profile data with error: \(error)")
                }
            }
        }
    }
    
    public func addInfoToUser(using userID: String, console: String, character: String, onlieTag: String) {
        let child = usersRef.child(userID)
        child.child("console").setValue(console)
        child.child("character").setValue(character)
        child.child("onlineTag").setValue(onlieTag)
       self.delegate.didAddInfoToUser(self)
        
    }
    
    
    //MARK: Changes users current user name to a new user name
    public func switchUserName(using userUID: String, to newUserName: String ){
        let child = usersRef.child(userUID)
        child.child("userName").setValue(newUserName)
    }
    
    
    //TODO: delete user account and sign them out
}
