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

protocol PhotoDownloadDelegate: class {
  func photoHasFinishedDownloading(_: UIImage)
  func noPhotosToShow()
}

class PhotoManager {
  
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
  
  // MARK: - Upload
  // storage
  func upload(photo: UIImage, location: CLLocation) {
    guard let imageData = UIImageJPEGRepresentation(photo, 0.1) else {
      return
    }
    let uidString = NSUUID().uuidString
    let storageRef = Storage.storage().reference().child("photos").child("\(uidString).jpg")
    
    // async upload to firebase
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
        self.saveDownloadURLForPhoto(with: uidString, url: url.absoluteString)
        self.saveLocationDataForPhoto(with: uidString, location: location)
      })
    })
  }
  
  // database
  private func saveDownloadURLForPhoto(with uidString: String, url: String) {
    guard let uid = Auth.auth().currentUser?.uid else {
      return
    }
    let dbRef = Database.database().reference().child("posts").child(uidString)
    let downloadURL = url
    let values: [String: Any] = ["download_URL": downloadURL,
                                 "posted_by": uid,
                                 "likes": 1,
                                 "dislikes": 0,
                                 "date": Date().description]
    dbRef.updateChildValues(values)
  }
  
  // geoFire
  private func saveLocationDataForPhoto(with uidString: String, location: CLLocation) {
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
  private var keyCollector = [String]()
  
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
    defer { downloadNextPost() }
    guard let postID = keyCollector.first else {
      return
    }
    
    let dislikesRef = dbPostsRef.child(postID).child("dislikes")
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
