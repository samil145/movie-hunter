//
//  FirebasePersistenceManager.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 04.10.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

enum PersistenceActionType
{
    case add, remove
}

class FirebasePersistenceManager {
    static let shared = FirebasePersistenceManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    private func getUserDocumentRef() -> DocumentReference? {
        guard let userUID = Auth.auth().currentUser?.uid else { return nil }
        return db.collection("users").document(userUID)
    }
    
    func isInFavorites(movieID: Int, isMovie: Bool, completion: @escaping (Bool) -> Void) {
        guard let userRef = getUserDocumentRef() else {
            completion(false)
            return
        }
        
        let ID = movieID * 10 + (isMovie ? 1 : 0)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists,
               let favorites = document.data()?["favorites"] as? [Int],
               favorites.contains(ID) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func updateWith(movieID: Int, isMovie: Bool, actionType: PersistenceActionType, completion: @escaping (Error?) -> Void) {
        guard let userRef = getUserDocumentRef() else {
            completion(NSError(domain: "FirebasePersistenceManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let document = document, document.exists else {
                completion(NSError(domain: "FirebasePersistenceManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User document does not exist"]))
                return
            }
            
            var favorites = document.data()?["favorites"] as? [Int] ?? []
            
            let ID = movieID * 10 + (isMovie ? 1 : 0)
            
            switch actionType {
            case .add:
                if !favorites.contains(ID) {
                    favorites.append(ID)
                }
            case .remove:
                favorites.removeAll { $0 == ID }
            }
            
            userRef.updateData(["favorites": favorites]) { error in
                completion(error)
            }
        }
    }
    
    func retrieveFavorites(completion: @escaping (Result<[Int], Error>) -> Void) {
        guard let userRef = getUserDocumentRef() else {
            completion(.failure(NSError(domain: "FirebasePersistenceManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists,
               let favorites = document.data()?["favorites"] as? [Int] {
                completion(.success(favorites))
            } else {
                completion(.success([]))
            }
        }
    }
}
