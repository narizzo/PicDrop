//
//  UUIdMetadataDownloadProcedure.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 10/9/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import ProcedureKit

class UUIdMetadataDownloadProcedure: Procedure { //RepeatProcedure<Operation> {
  
  private var uuid: UUID
  private let successHandler: (PartialPost) -> Void
  
  init(uuid: UUID, successHandler: @escaping (PartialPost) -> Void) {
    self.uuid = uuid
    self.successHandler = successHandler
    super.init()
  }
  
  override func execute() {
    defer { (self.error != nil) ? (finish(with: self.error)) : (finish()) }
    
    let idString = uuid.uuidString
    Constants.Firebase.Database.postsRef.child(idString).observeSingleEvent(of: .value, with: { (snapshot) in
      // much of this data is currently UNUSED
      guard let date = snapshot.childSnapshot(forPath: "date").value as? Date,
        let dislikes = snapshot.childSnapshot(forPath: "dislikes").value as? Int32,
        let downloadURL = snapshot.childSnapshot(forPath: "download_URL").value as? URL,
        let likes = snapshot.childSnapshot(forPath: "likes").value as? Int32
        else { return }
      
      let imageRef = Constants.Firebase.Storage.storageRef.reference(forURL: downloadURL.absoluteString)
      
      imageRef.getData(maxSize: 1 * 2436 * 1125, completion: { (data, error) in
        guard error == nil else {
          self.error = error
          return
        }
        guard let imageData = data,
          let image = UIImage(data: imageData) else {
          self.error = error
          // need to fill in custom error here
          return
        }
        self.successHandler(PartialPost(uuid: self.uuid, image: image))
      })
      
    }) { (error) in
      print("Error: \(error)")
    }
  }
}
