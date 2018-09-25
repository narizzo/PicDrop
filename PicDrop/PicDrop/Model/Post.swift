//
//  Post.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreLocation

struct Post {
  private(set) var date: Date
  var uuid: UUID
  var image: UIImage
  var location: CLLocation
  
  var downloadURL: URL?
  
  var downvotes: Int32 = 0
  var upvotes: Int32 = 1
  
  init(date: Date = Date(), uuid: UUID, image: UIImage, location: CLLocation, downloadURL: URL? = nil) {
    self.date = date
    self.uuid = uuid
    self.image = image
    self.location = location
    self.downloadURL = downloadURL
  }
  
}

extension Post: Equatable {
  static func == (lhs: Post, rhs: Post) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}
