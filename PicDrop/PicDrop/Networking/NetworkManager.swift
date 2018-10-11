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
import ProcedureKit

class NetworkManager {
  
  // MARK: - Instance Variables
  var cache: Cache
  private let locationManager: CLLocationManager
  private let geoFireRef = GeoFire(firebaseRef: Constants.Firebase.Database.postLocationsRef)
  
  private var activeUUIdRequests = Set<UUID>()
  //private var activeNetworkRequests = [RequestType: Operation]()
  private var isFetchingNearbyUUIds = false
  
  private var procedureQueue = ProcedureQueue()
  
  private lazy var operationQueue: OperationQueue = {
    let oq = OperationQueue()
    oq.qualityOfService = .userInitiated
    return oq
  }()
  
  // MARK: - Init
  init(cache: Cache, locationManager: CLLocationManager) {
    self.cache = cache
    self.locationManager = locationManager
  }
  
  private lazy var keysHandler: ([String]) -> Void = { [weak cache, weak self] in
    cache?.processKeys($0)
    self?.isFetchingNearbyUUIds = false
  }
  
  // MARK: - Query Location + Download
  func fetchNearbyPostUUIDs() {
    self.procedureQueue.addOperation(NearbyUUIdsDownloadProcedure(cache: cache, networkManager: self))
  }
  
  func fetchData(for uuid: UUID) {
    let successHandler: (PartialPost) -> Void = { partialPost in
      self.cache.processPartialPost(partialPost)
    }
    
    self.procedureQueue.addOperation(UUIdMetadataDownloadProcedure(uuid: uuid, successHandler: successHandler))
  }
      
//    guard !self.activeUUIdRequests.contains(uuid) else { return }
//
//    self.activeUUIdRequests.insert(uuid)
//    defer { self.activeUUIdRequests.remove(uuid) }
//
//    let idString = uuid.uuidString
//    // change to download all metadata instead of just the download_URL
//    Constants.Firebase.Database.postsRef.child(idString).child("download_URL").observeSingleEvent(of: .value, with: { (snapshot) in
//      if let downloadURL = snapshot.value as? String {
//        let imageRef = Constants.Firebase.Storage.storageRef.reference(forURL: downloadURL)
//        imageRef.getData(maxSize: 1 * 2436 * 1125, completion: { (data, error) in
//          guard error == nil else {
//            print(error!.localizedDescription)
//            return
//          }
//          guard let imageData = data else {
//            return
//          }
//          self.cache.process(imageData, for: uuid)
//          // change code structure so that the success handler mutates the cache data not the vc data, and then the cache notifies that its data has changed
//          successHandler()
//        })
//      }
//    }) { (error) in
//      print("Error: \(error)")
//    }
//  }
  
  
  // MARK: - Upload
  // storage
  func upload(post: Post) {
    // make an operation for this
    
    DispatchQueue.main.async {
      guard let userID = Auth.auth().currentUser?.uid,
        let imageData = UIImageJPEGRepresentation(post.image, 0.1) else { return }
      
      let postIdString = post.uuid.uuidString
      let storageRef = Constants.Firebase.Storage.storagePhotosRef.child("\(postIdString).jpg")
      
      // upload image to storage
      storageRef.putData(imageData, metadata: nil) { (_, error) in
        guard error == nil else {
          print("error: \(error!.localizedDescription)")
          return
        }
        
        // get image downloadURL
        storageRef.downloadURL { (url, error) in
          guard error == nil,
            let url = url else {
              // notify user of error
              return
          }
          
          // upload image metadata
          let dbRef = Constants.Firebase.Database.postsRef.child(postIdString)
          let downloadURL = url.absoluteString
          print("DownloadURL: \(downloadURL)")
          let values: [String: Any] = ["download_URL": downloadURL,
                                       "posted_by": userID,
                                       "upvotes": 1,
                                       "downvotes": 0,
                                       "date": post.date.description]
          dbRef.updateChildValues(values)
        }
        
        // upload image location
        let dbRef = Database.database().reference().child("post_locations")
        let geoFire = GeoFire(firebaseRef: dbRef)
        geoFire.setLocation(post.location, forKey: postIdString) { (error) in
          if let error = error {
            print(error)
          } else {
            print("Successfully saved post location to Firebase")
          }
        }
      }
    }
  }
  
  //  func uploadImageToStorage(_ image: UIImage) {
  //    guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
  //      return
  //    }
  //
  //    let uidString = NSUUID().uuidString
  //    let storageRef = Constants.Firebase.Storage.storagePhotosRef.child("\(uidString).jpg")
  //
  //    // save image to storage
  //    storageRef.putData(imageData, metadata: nil) { (_, error) in
  //      guard error == nil else {
  //        print("error: \(error!.localizedDescription)")
  //        return
  //      }
  //
  //      // get image downloadURL
  //      storageRef.downloadURL { (url, error) in
  //        guard error == nil,
  //          let url = url else {
  //            // notify user of error
  //            return
  //        }
  //
  //        // save downloadURL
  //        self.storePhotoDownloadURL(uidString: uidString, url: url.absoluteString)
  //        //self.storeLocationForPhoto(uidString: uidString, location: frozenLocation)
  //      }
  //    }
  //  }
  
  
  // database
  //  func storePhotoDownloadURL(uidString: String, url: String) {
  //    guard let uid = Auth.auth().currentUser?.uid else {
  //      return
  //    }
  //    let dbRef = Constants.Firebase.Database.postsRef.child(uidString)
  //    let downloadURL = url
  //    let values: [String: Any] = ["download_URL": downloadURL,
  //                                 "posted_by": uid,
  //                                 "upvotes": 1,
  //                                 "downvotes": 0,
  //                                 "date": Date().description]
  //    dbRef.updateChildValues(values)
  //  }
  
  // geoFire
  //  func storeLocationForPhoto(uidString: String, location: CLLocation) {
  //    DispatchQueue.global(qos: .background).async {
  //      let dbRef = Database.database().reference().child("post_locations")
  //      let geoFire = GeoFire(firebaseRef: dbRef)
  //      geoFire.setLocation(location, forKey: uidString) { (error) in
  //        if let error = error {
  //          print(error)
  //        } else {
  //          print("Successfully saved post location to Firebase")
  //        }
  //      }
  //    }
  //  }
  
  
  func vote(on post: PartialPost, with vote: PostVote) {
    let postIDString = post.uuid.uuidString
    let voteString: String
    vote.rawValue == 1 ? (voteString = "upvote") : (voteString = "downvote")
    
    let dislikesRef = Constants.Firebase.Database.postsRef.child(postIDString).child(voteString)
    dislikesRef.runTransactionBlock({ (data) -> TransactionResult in
      if let value = data.value as? Int {
        data.value = value + vote.rawValue
      }
      return TransactionResult.success(withValue: data)
    }) { (error, completion, _) in // error, completion, snapshot
      guard error == nil else {
        // alert user of error
        return
      }
      if completion {
        self.updateUserVotes(for: postIDString, with: vote)
      }
    }
  }
  
  
  private func updateUserVotes(for postID: String, with vote: PostVote) {
    guard let userRef = Constants.Firebase.Auth.userRef else {
      return
    }
    userRef.child("posts_voted_on").child(postID).setValue(vote.rawValue)
  }
  
}

//
//extension NetworkManager: CLLocationManagerDelegate {
//  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    print("did update locations - automatically calling fetch posts")
//    fetchPosts()
//  }
//}
//
//extension NetworkManager: NetworkOperationsDelegate {
//  func networkOperations(_ networkOperations: OperationQueue, didFinishDownloadingKeys keys: [String]) {
//    cache.process(keys)
//  }



////
////  PhotoUploadManager.swift
////  PicDrop
////
////  Created by Nicholas Rizzo on 7/16/18.
////  Copyright © 2018 Nicholas Rizzo. All rights reserved.
////
//
//import UIKit
//import FirebaseAuth
//import FirebaseStorage
//import FirebaseDatabase
//import GeoFire
//
//class NetworkManager {
//
//  // MARK: - Instance Variables
//  var cache: Cache
//  private let locationManager: CLLocationManager
//  private let geoFireRef = GeoFire(firebaseRef: Constants.Firebase.Database.postLocationsRef)
//  private lazy var operationQueue: OperationQueue = {
//    let oq = OperationQueue()
//    oq.qualityOfService = .userInitiated
//    //oq.maxConcurrentOperationCount = 1 // shouldn't need this considering its a serial queue
//    return oq
//  }()
//
//  // MARK: - Init
//  init(cache: Cache, locationManager: CLLocationManager) {
//    self.cache = cache
//    self.locationManager = locationManager
//  }
//
//  private lazy var keysHandler: ([String]) -> Void = { [weak cache] in
//    cache?.processKeys($0)
//  }
//
//  // MARK: - Query Location + Download
//  func fetchNearbyPostUUIDs() {
//    // group these operations together
//    let requestLocationOperation = RequestLocationWhenInUseOperation()
//    let locationOperation = LocationOperation(locationManager: locationManager)
//    let locationQueryOperation = LocationQueryOperation(handler: keysHandler)
//
//    // set dependencies
//    locationOperation.addDependency(requestLocationOperation)
//    locationQueryOperation.addDependency(locationOperation)
//
//    // add operations
//    operationQueue.addOperations([requestLocationOperation, locationOperation, locationQueryOperation], waitUntilFinished: false)
//  }
//
//
//  func fetchData(for uuid: UUID) {
//    let idString = uuid.uuidString
//    // change to download all metadata instead of just the download_URL
//    Constants.Firebase.Database.postsRef.child(idString).child("download_URL").observeSingleEvent(of: .value, with: { (snapshot) in
//      if let downloadURL = snapshot.value as? String {
//        let imageRef = Constants.Firebase.Storage.storageRef.reference(forURL: downloadURL)
//        imageRef.getData(maxSize: 1 * 2436 * 1125, completion: { (data, error) in
//          guard error == nil else {
//            print(error!.localizedDescription)
//            return
//          }
//
//          if let imageData = data {
//            self.cache.process(imageData, for: uuid)
//          }
//        })
//      }
//
//    }) { (error) in
//      print("Error: \(error)")
//    }
//  }
//
//
//  // MARK: - Upload
//  // storage
//  func upload(post: Post) {
//    // make an operation for this
//
//    DispatchQueue.main.async {
//      guard let userID = Auth.auth().currentUser?.uid,
//        let imageData = UIImageJPEGRepresentation(post.image, 0.1) else { return }
//
//      let postIdString = post.uuid.uuidString
//      let storageRef = Constants.Firebase.Storage.storagePhotosRef.child("\(postIdString).jpg")
//
//      // upload image to storage
//      storageRef.putData(imageData, metadata: nil) { (_, error) in
//        guard error == nil else {
//          print("error: \(error!.localizedDescription)")
//          return
//        }
//
//        // get image downloadURL
//        storageRef.downloadURL { (url, error) in
//          guard error == nil,
//            let url = url else {
//              // notify user of error
//              return
//          }
//
//          // upload image metadata
//          let dbRef = Constants.Firebase.Database.postsRef.child(postIdString)
//          let downloadURL = url.absoluteString
//          print("DownloadURL: \(downloadURL)")
//          let values: [String: Any] = ["download_URL": downloadURL,
//                                       "posted_by": userID,
//                                       "upvotes": 1,
//                                       "downvotes": 0,
//                                       "date": post.date.description]
//          dbRef.updateChildValues(values)
//        }
//
//        // upload image location
//        let dbRef = Database.database().reference().child("post_locations")
//        let geoFire = GeoFire(firebaseRef: dbRef)
//        geoFire.setLocation(post.location, forKey: postIdString) { (error) in
//          if let error = error {
//            print(error)
//          } else {
//            print("Successfully saved post location to Firebase")
//          }
//        }
//      }
//    }
//  }
//
////  func uploadImageToStorage(_ image: UIImage) {
////    guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
////      return
////    }
////
////    let uidString = NSUUID().uuidString
////    let storageRef = Constants.Firebase.Storage.storagePhotosRef.child("\(uidString).jpg")
////
////    // save image to storage
////    storageRef.putData(imageData, metadata: nil) { (_, error) in
////      guard error == nil else {
////        print("error: \(error!.localizedDescription)")
////        return
////      }
////
////      // get image downloadURL
////      storageRef.downloadURL { (url, error) in
////        guard error == nil,
////          let url = url else {
////            // notify user of error
////            return
////        }
////
////        // save downloadURL
////        self.storePhotoDownloadURL(uidString: uidString, url: url.absoluteString)
////        //self.storeLocationForPhoto(uidString: uidString, location: frozenLocation)
////      }
////    }
////  }
//
//
//  // database
////  func storePhotoDownloadURL(uidString: String, url: String) {
////    guard let uid = Auth.auth().currentUser?.uid else {
////      return
////    }
////    let dbRef = Constants.Firebase.Database.postsRef.child(uidString)
////    let downloadURL = url
////    let values: [String: Any] = ["download_URL": downloadURL,
////                                 "posted_by": uid,
////                                 "upvotes": 1,
////                                 "downvotes": 0,
////                                 "date": Date().description]
////    dbRef.updateChildValues(values)
////  }
//
//  // geoFire
////  func storeLocationForPhoto(uidString: String, location: CLLocation) {
////    DispatchQueue.global(qos: .background).async {
////      let dbRef = Database.database().reference().child("post_locations")
////      let geoFire = GeoFire(firebaseRef: dbRef)
////      geoFire.setLocation(location, forKey: uidString) { (error) in
////        if let error = error {
////          print(error)
////        } else {
////          print("Successfully saved post location to Firebase")
////        }
////      }
////    }
////  }
//
//
//  func vote(on post: Post, with vote: PostVote) {
//    let postIDString = post.uuid.uuidString
//    let voteString: String
//    vote.rawValue == 1 ? (voteString = "upvote") : (voteString = "downvote")
//
//    let dislikesRef = Constants.Firebase.Database.postsRef.child(postIDString).child(voteString)
//    dislikesRef.runTransactionBlock({ (data) -> TransactionResult in
//      if let value = data.value as? Int {
//        data.value = value + vote.rawValue
//      }
//      return TransactionResult.success(withValue: data)
//    }) { (error, completion, _) in // error, completion, snapshot
//      guard error == nil else {
//        // alert user of error
//        return
//      }
//      if completion {
//        self.updateUserVotes(for: postIDString, with: vote)
//      }
//    }
//  }
//
//
//  private func updateUserVotes(for postID: String, with vote: PostVote) {
//    guard let userRef = Constants.Firebase.Auth.userRef else {
//      return
//    }
//    userRef.child("posts_voted_on").child(postID).setValue(vote.rawValue)
//  }
//
//}
//
////
////extension NetworkManager: CLLocationManagerDelegate {
////  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////    print("did update locations - automatically calling fetch posts")
////    fetchPosts()
////  }
////}
////
////extension NetworkManager: NetworkOperationsDelegate {
////  func networkOperations(_ networkOperations: OperationQueue, didFinishDownloadingKeys keys: [String]) {
////    cache.process(keys)
////  }
