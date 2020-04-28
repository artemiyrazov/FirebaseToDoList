//
//	Task.swift
// 	FirebaseToDoList
//

import Foundation
import Firebase

struct Task {
    let title: String
    let userId: String
    let reference: DatabaseReference?
    var completed = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.reference = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        reference = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return (["title": title, "userId": userId, "completed": completed])
    }
}
