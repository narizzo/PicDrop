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
}

class PhotoDownloadManager {
  
  weak var delegate: PhotoDownloadDelegate?
  
  private let storage = Storage.storage()
  private var data = Data()
  
  private let dbPostLocationsRef = Database.database().reference().child("post_locations")
  private let dbPostsRef = Database.database().reference().child("posts")
  private let storageRef = Storage.storage().reference().child("photos")
  
  var keyCollector = [String]()
  
  func getNearbyPosts() {
    guard let location = locationManager.location else {
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
  
  func downloadNextPost() {
    guard let postID = keyCollector.first else {
      return
    }
    self.keyCollector.removeFirst()
    
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
