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
  
  // MARK: - Cell Reuse
  enum CellReuse {
    static let settingValueCell = "settingValueCellReuse"
  }
  
  // MARK: - Core Data
  enum CoreData {
    static let modelName = "PicDrop"
  }
  
  enum Cache {
    static let cacheName = "nearbyPostsCache"
  }
  
  // MARK: - Local Files
  enum FileSystem {
    static let previouslyVotedPostsFileName = "previouslyVotedPostsFileName"
  }
  
  // MARK: - Networking
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
      static let storageRef = FirebaseStorage.Storage.storage()
      static let storagePhotosRef = storageRef.reference().child("photos")
    }
  }
  
  // MARK: - KVO Notification
  enum NotificationName {
    static let nearbyPosts = Notification.Name("com.adriftingup.nearbyPosts")
    static let imageDataHasDownloaded = Notification.Name("com.adriftingup.imageDataHasDownloaded")
  }
  
  // MARK: - Operation
  enum OperationState {
    static let isCancelled = "isCancelled"
    static let isAsynchronous = "isAsynchronous"
    static let isExecuting = "isExecuting"
    static let isFinished = "isFinished"
    static let isReady = "isReady"
    static let dependencies = "dependencies"
    static let queuePriority = "queuePriority"
    static let completionBlock = "completionBlock"
  }
  
  // MARK: - UserInfo
  enum UserInfo {
    enum Key {
      static let photo = "photo"
    }
  }
  
}
