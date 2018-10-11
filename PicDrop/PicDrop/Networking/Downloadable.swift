//
//  DownloadManager.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/27/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GeoFire


protocol Downloadable {
  
}

extension Downloadable {
  func execute() {
    print("execute download task")
  }
}
