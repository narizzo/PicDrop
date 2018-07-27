//
//  ViewController.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 6/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import GeoFire

class PostsViewController: UIViewController {
  
  private var imageView = UIImageView()
  private var actionBar = UIView()
  
  private let storage = Storage.storage()
  private var data = Data()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    loadNextPicture()
  }
  
  private func loadNextPicture() {
    print("load next picture")
    guard let location = locationManager.location else {
      return
    }
    let geoFireRef = Database.database().reference().child("post_locations")
    let geoFire = GeoFire(firebaseRef: geoFireRef)
  
    //geoFire.query(at: location, withRadius: 0.1)
    let circleQuery = geoFire.query(at: location, withRadius: 0.1)
    var queryHandle = circleQuery.observe(.keyEntered) { (key, location) in
      print("\(key) : at \(location)")
    }
  }
    
//    let circleQuery = geoFire.query(at: location, withRadius: 0.1) {
//      //circleQuery.queriesForCurrentCriteria()
//      circleQuery.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
//
//      })
//
//      circleQuery.observeReady({
//
//      })
//    }
    
    
//    let dbRef = Database.database().reference().child("posts")
//    dbRef.observe(.value, with: { (snapshot) in
//      //let downloadURL = snapshot.value as! String
//      let downloadURL = "https://firebasestorage.googleapis.com/v0/b/picdrop-be8dd.appspot.com/o/photos%2F6542889C-6125-45BC-AD7B-82B3171AD870.jpg?alt=media&token=3bc14fb4-fc39-47b9-8942-148663dc5751"
//      let storageRef = self.storage.reference(forURL: downloadURL)
//      storageRef.getData(maxSize: 1 * 2436 * 1125) { ( data, error) -> Void in
//        guard error == nil else {
//          print(error!.localizedDescription)
//          return
//        }
//        guard let data = data else {
//          return
//        }
//        if let photo = UIImage(data: data) {
//          DispatchQueue.main.async {
//            self.imageView.image = photo
//          }
//        }
//      }
//    }) { (error) in
//      print(error)
//    }
  
  
  //    DispatchQueue.global(qos: .background).async {
  //      let ref = Database.database().reference().child("posts")
  //      let downloadURL = ref.child("6542889C-6125-45BC-AD7B-82B3171AD870").url
  //      print(downloadURL)
  //      let photoRef = self.storage.reference(forURL: downloadURL)
  //
  //      // iPhone X resolution
  //      let width: Int64 = 1125
  //      let height: Int64 = 2436
  //
  //      photoRef.getData(maxSize: width * height) { (data, error) in
  //        if let error = error {
  //          print(error)
  //        } else {
  //          self.imageView.image = UIImage(data: data!)
  //        }
  //      }
  //
  //    }
  //    //ref.child("6542889C-6125-45BC-AD7B-82B3171AD870").observeSingleEvent(of: , with: l, withCancel: )
  //
  //
  //  }
  
}
