//
//  UserManager.swift
//  PinkyPromise
//
//  Created by Yumna Ahmed on 2025-01-11.
//
import FirebaseFirestore

class UserManager {
    private let db = Firestore.firestore()

    func getUserById(id: String, completion: @escaping (User?) -> Void) {
        let userRef = db.collection("users").document(id)
        userRef.getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = snapshot?.data(),
                  let email = data["email"] as? String else {
                completion(nil)
                return
            }

            // Create and return the User object
            let user = User(id: id, email: email)
            completion(user)
        }
    }
}



