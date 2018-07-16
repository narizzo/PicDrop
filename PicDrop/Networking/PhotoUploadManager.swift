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

class PhotoUploadManager {
  
  // MARK: - Photo Storage and Database Update
  func upload(photo: UIImage) {
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
      })
    })
  }
  
  private func saveDownloadURLForPhoto(with uidString: String, url: String) {
    guard let uid = Auth.auth().currentUser?.uid else {
      return
    }
    let dbRef = Database.database().reference().child("posts").child(uidString)
    let downloadURL = url
    let values: [String: String] = ["download_URL": downloadURL, "posted_by": uid]
    dbRef.updateChildValues(values)
  }
}
