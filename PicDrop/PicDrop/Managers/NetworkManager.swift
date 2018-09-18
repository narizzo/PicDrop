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

class NetworkManager: NSObject {
  
  // MARK: - Instance Variables
  var cache: Cache
  private let geoFireRef = GeoFire(firebaseRef: Constants.Firebase.Database.postLocationsRef)
  private lazy var operationQueue: OperationQueue = {
    let oq = OperationQueue()
    oq.qualityOfService = .userInitiated
    //oq.maxConcurrentOperationCount = 1 // shouldn't need this considering its a serial queue
    return oq
  }()
  
  // MARK: - Init
  init(cache: Cache) {
    self.cache = cache
    super.init()
  }
  
  private lazy var keysHandler: ([String]) -> Void = { [weak cache] in
    cache?.processKeys($0)
  }
  // MARK: - Query Location + Download
  func fetchPosts() {
    let locationOperation = LocationOperation()
    let locationQueryOperation = LocationQueryOperation(handler: keysHandler)
    locationQueryOperation.addDependency(locationOperation)
    operationQueue.addOperations([locationOperation, locationQueryOperation], waitUntilFinished: false)
  }
  
//  func fetchPhoto(for post: Post) {
//    guard let postID = post.uuid?.uuidString else {
//      return
//    }
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
//          if let imageData = data {
//            self.cache.process(imageData, for: postID)
//          }
//        })
//      }
//
//    }) { (error) in
//      print("Error: \(error)")
//    }
//  }
//
//}
//
//  // MARK: - Upload
//  // storage
//  func uploadPhotoToStorage(photo: UIImage) {
//    guard let imageData = UIImageJPEGRepresentation(photo, 0.1),
//      let frozenLocation = locationManager.location else {
//        return
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
//        self.storeLocationForPhoto(uidString: uidString, location: frozenLocation)
//      }
//    }
//  }
//
//
//  // database
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
//
//  // geoFire
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
//
//  func vote(on photo: Photo, with vote: PostVote) {
//    let postIDString = photo.uuid.uuidString
//    let voteString: String
//    vote.rawValue == 1 ? (voteString = "upvote") : (voteString = "downvote")
//
//    let dislikesRef = Constants.Firebase.Database.postsRef.child(postIDString).child(voteString)
//    dislikesRef.runTransactionBlock({ (data) -> TransactionResult in
//      if let value = data.value as? Int {
//        data.value = value + vote.rawValue
//      }
//      return TransactionResult.success(withValue: data)
//    }) { (error, completion, snapshot) in
//      if let error = error {
//        print(error)
//      }
//      self.updateUserVotes(for: postIDString, with: vote)
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
}
