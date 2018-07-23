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

class PhotoUploadManager {
  
  // MARK: - Photo Storage
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
  
  // MARK: - Database
  private func saveDownloadURLForPhoto(with uidString: String, url: String) {
    guard let uid = Auth.auth().currentUser?.uid else {
      return
    }
    let dbRef = Database.database().reference().child("posts").child(uidString)
    let downloadURL = url
    let values: [String: String] = ["download_URL": downloadURL, "posted_by": uid]
    dbRef.updateChildValues(values)
  }
  
  // MARK: - GeoFire
  private func saveLocationDataForPhoto(with uidString: String, location: CLLocation) {
    /*
     ...what happens to DispatchQueues when a view controller is deallocated?
     
     Those queues will continue to exist, as will any dispatched blocks, until
        (a) all dispatched blocks finish; and
        (b) there are no more strong references to the queue.
     
     So if you asynchronously dispatch blocks with weak references to self (i.e. the view controller),
     they will continue to run after the view controller is released.
     This is why it's critical to not use unowned in this context.
     
     */
    DispatchQueue.global(qos: .background).async {
      let dbRef = Database.database().reference().child("post_locations")
      let geoFire = GeoFire(firebaseRef: dbRef)
      geoFire.setLocation(location, forKey: uidString) { (error) in
        if let error = error {
          print(error)
        } else {
          print("Successfully saved post location to GeoFire")
        }
      }
    }
  }
  
}
