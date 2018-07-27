//
//  PhotoDownloadManager.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/18/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GeoFire

protocol PhotoDownloadDelegate: class {
  func photoHasFinishedDownloading(_: UIImage)
  func noPhotosToShow()
}

class PhotoDownloadManager {
  
  weak var delegate: PhotoDownloadDelegate?
  
  private let storage = Storage.storage()
  private var data = Data()
  private lazy var userRef: DatabaseReference? = {
    guard let uid = Auth.auth().currentUser?.uid else {
      return nil
    }
    let ref = Database.database().reference().child("users").child(uid)
    return ref
  }()
  private let dbPostLocationsRef = Database.database().reference().child("post_locations")
  private let dbPostsRef = Database.database().reference().child("posts")
  private let storageRef = Storage.storage().reference().child("photos")
  
  
  var keyCollector = [String]()
  
  func getNearbyPosts() {
    guard let location = LocationManager.shared.locationManager.location else {
      return
    }
    let geoFire = GeoFire(firebaseRef: dbPostLocationsRef)
    
    let circleQuery = geoFire.query(at: location, withRadius: 0.1)
    
    let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
    dispatchQueue.async {
      let _ = circleQuery.observe(.keyEntered) { (key: String?, _: CLLocation?) in
        if let key = key {
          self.keyCollector.append(key)
        }
      }
    }
    
    circleQuery.observeReady {
      circleQuery.removeAllObservers()
      self.downloadNextPost()
    }
  }
  
  func voteOnPost(with vote: PictureVote) {
    print("Voted \(vote.rawValue)")
    defer { downloadNextPost() }
    guard let postID = keyCollector.first else {
      return
    }
    
//    let dislikesRef = dbPostsRef.child(postID).child("dislikes")
//    dislikesRef.runTransactionBlock { (data) -> TransactionResult in
//      if let value = data.value as? Int {
//        data.value = value + vote.rawValue
//      }
//      return TransactionResult.success(withValue: data)
//
//    }
//
    let dislikesRef = dbPostsRef.child(postID).child("dislikes")
    dislikesRef.runTransactionBlock({ (data) -> TransactionResult in
      if let value = data.value as? Int {
        data.value = value + vote.rawValue
      }
      return TransactionResult.success(withValue: data)
    }) { (error, completion, snapshot) in
      print(error?.localizedDescription)
      self.updateUserVotes(for: postID, with: vote)
    }
  }
  
  private func updateUserVotes(for postID: String, with vote: PictureVote) {
    guard let userRef = userRef else {
      return
    }
    userRef.child("posts_voted_on").child(postID).setValue(vote.rawValue)
  }
  
  func downloadNextPost() {
    guard let postID = keyCollector.first else {
      self.delegate?.noPhotosToShow()
      return
    }
    //self.keyCollector.removeFirst()
    
    dbPostsRef.child(postID).child("download_URL").observeSingleEvent(of: .value, with: { (snapshot) in
      if let downloadURL = snapshot.value as? String {
        let image = self.storage.reference(forURL: downloadURL)
        image.getData(maxSize: 1 * 2436 * 1125, completion: { (data, error) in
          guard error == nil else {
            print(error!.localizedDescription)
            return
          }
          
          guard let imageData = data else {
            return
          }
          
          if let photo = UIImage(data: imageData) {
            self.delegate?.photoHasFinishedDownloading(photo)
          }
        })
      }
      
    }) { (error) in
      print("Error: \(error)")
    }
  }
}


public enum PictureVote: Int {
  case dislike = -1
  case like = 1
}
