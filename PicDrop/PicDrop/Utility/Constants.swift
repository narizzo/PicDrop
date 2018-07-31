//
//  Constants.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GeoFire

enum Constants {
  
  enum CellReuse {
    static let settingValueCell = "settingValueCellReuse"
  }
  
  enum Firebase {
    
    enum Auth {
      static let userRef: DatabaseReference? = {
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {
          return nil
        }
        let ref = FirebaseDatabase.Database.database().reference().child("users").child(uid)
        return ref
      }()
    }
    
    enum Database {
      static let postLocationsRef = FirebaseDatabase.Database.database().reference().child("post_locations")
      static let postsRef = FirebaseDatabase.Database.database().reference().child("posts")
    }
    
    enum Storage {
      static let storageRef = FirebaseStorage.Storage.storage().reference().child("photos")
    }
  }
  
}
