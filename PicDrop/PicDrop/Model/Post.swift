//
//  Post.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreLocation

struct PartialPost {
  var uuid: UUID
  var image: UIImage
  
  init(uuid: UUID, image: UIImage) {
    self.uuid = uuid
    self.image = image
  }
}

extension PartialPost {
  typealias CompletionInfo = (location: CLLocation, downloadURL: URL)
  
  func completed(with info: CompletionInfo) -> Post {
    return Post(uuid: uuid, image: image, location: info.location, downloadURL: info.downloadURL)
  }
}


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
