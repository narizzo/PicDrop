//
//  PhotoUploadManager.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/16/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GeoFire
import CoreData

final class NetworkManager { // subclass NSObject if using KVO
  
  // MARK: - Internal
  private var cache: Cache
  
  // MARK: - Init
  init(cache: Cache) {
    self.cache = cache
  }
  // MARK: - Upload
  // storage
  func uploadPhotoToStorage(photo: UIImage, location: CLLocation) {
    guard let imageData = UIImageJPEGRepresentation(photo, 0.1) else {
      return
    }
    // Firebase storage doesn't have childByAutoID
    let uidString = NSUUID().uuidString
    //let storageRef = Storage.storage().reference().child("photos").child("\(uidString).jpg")
    let storageRef = Constants.Firebase.Storage.storagePhotosRef.child("\(uidString).jpg")
    
    // * SHOULD UPDATE THIS TO USE 'putFile' IN ORDER TO PREVENT SITUATIONS WHERE APP IS EXITED BEFORE UPLOAD COMPLETES * //
    storageRef.putData(imageData, metadata: nil, completion: { (_, error) in
      guard error == nil else {
        print("error: \(error!.localizedDescription)")
        return
      }
      
      storageRef.downloadURL(completion: { (url, error) in
        guard error == nil,
          let url = url else {
            return
        }
        self.storePhotoMetadataInDatabase(with: uidString, url: url.absoluteString)
        self.saveLocationDataForPhoto(with: uidString, at: location)
      })
    })
  }
  
  // database
  func storePhotoMetadataInDatabase(with uidString: String, url: String) {
    guard let uid = Auth.auth().currentUser?.uid else {
      return
    }
    //let dbRef = Database.database().reference().child("posts").child(uidString)
    let dbRef = Constants.Firebase.Database.postsRef.child(uidString)
    let downloadURL = url
    let values: [String: Any] = ["download_URL": downloadURL,
                                 "posted_by": uid,
                                 "upvotes": 1,
                                 "downvotes": 0,
                                 "date": Date().description]
    dbRef.updateChildValues(values)
  }
  
  // geoFire
  func saveLocationDataForPhoto(with uidString: String, at location: CLLocation) {
    DispatchQueue.global(qos: .background).async {
      let dbRef = Database.database().reference().child("post_locations")
      let geoFire = GeoFire(firebaseRef: dbRef)
      geoFire.setLocation(location, forKey: uidString) { (error) in
        if let error = error {
          print(error)
        } else {
          print("Successfully saved post location to Firebase")
        }
      }
    }
  }
  
  // MARK: - Download
  func fetchPosts(near location: CLLocation) {
    var nearbyPostKeysCollector = [String]()
    
    let geoFire = GeoFire(firebaseRef: Constants.Firebase.Database.postLocationsRef)
    let circleQuery = geoFire.query(at: location, withRadius: 0.1)
    let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
    
    dispatchQueue.async {
      let _ = circleQuery.observe(.keyEntered) { (key: String?, _: CLLocation?) in
        if let key = key {
          nearbyPostKeysCollector.append(key)
        }
      }
    }
    circleQuery.observeReady {
      circleQuery.removeAllObservers()
      self.cache.process(nearbyPostKeysCollector)
    }
  }
  
  func vote(on postID: String, with vote: PostVote) {
    let voteString: String
    vote.rawValue == 1 ? (voteString = "upvote") : (voteString = "downvote")

    let dislikesRef = Constants.Firebase.Database.postsRef.child(postID).child(voteString)
    dislikesRef.runTransactionBlock({ (data) -> TransactionResult in
      if let value = data.value as? Int {
        data.value = value + vote.rawValue
      }
      return TransactionResult.success(withValue: data)
    }) { (error, completion, snapshot) in
      if let error = error {
        print(error)
      }
      self.updateUserVotes(for: postID, with: vote)
    }
  }
  
  private func updateUserVotes(for postID: String, with vote: PostVote) {
    guard let userRef = Constants.Firebase.Auth.userRef else {
      return
    }
    userRef.child("posts_voted_on").child(postID).setValue(vote.rawValue)
  }
  
  func downloadPhoto(for postID: String) {
    Constants.Firebase.Database.postsRef.child(postID).child("download_URL").observeSingleEvent(of: .value, with: { (snapshot) in
      if let downloadURL = snapshot.value as? String {
        let image = Constants.Firebase.Storage.storageRef.reference(forURL: downloadURL)
        image.getData(maxSize: 1 * 2436 * 1125, completion: { (data, error) in
          guard error == nil else {
            print(error!.localizedDescription)
            return
          }
          
          guard let imageData = data else {
            return
          }
          
          if let photo = UIImage(data: imageData) {
            //self.delegate?.networkClient(self, didFinishDownloading: Photo(id: postID, image: photo))
            /* pass data to cache */
          }
        })
      }
      
    }) { (error) in
      print("Error: \(error)")
    }
  }
  
//  func downloadNextPost() {
//    guard let postID = keyCollector.first else {
//      //delegate?.photoHasFinishedDownloading(nil)
//      return
//    }
//    //self.keyCollector.removeFirst()
//
//    Constants.Firebase.Database.postsRef.child(postID).child("download_URL").observeSingleEvent(of: .value, with: { (snapshot) in
//      if let downloadURL = snapshot.value as? String {
//        let image = Constants.Firebase.Storage.storageRef.reference(forURL: downloadURL)
//        image.getData(maxSize: 1 * 2436 * 1125, completion: { (data, error) in
//          guard error == nil else {
//            print(error!.localizedDescription)
//            return
//          }
//
//          guard let imageData = data else {
//            return
//          }
//
//          if let photo = UIImage(data: imageData) {
//            //self.delegate?.photoHasFinishedDownloading(photo)
//
//          }
//        })
//      }
//
//    }) { (error) in
//      print("Error: \(error)")
//    }
//  }
  
  
}
