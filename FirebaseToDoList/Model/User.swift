//
//	User.swift
// 	FirebaseToDoList
//

import Foundation
import Firebase

//using 'UserStruct' because 'User' reserved by Firebase
struct UserStruct  {
    
    let uid: String
    let email: String
    
    init (user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
