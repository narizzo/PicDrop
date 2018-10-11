//
//  PostsVC+QueueDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension PostsViewController: QueueDelegate {
  func queueDidRequestElements<T>(_ queue: Queue<T>) {
    switch T.self {
    case is UUID.Type:
      fetchData()
    case is PartialPost.Type:
      fetchPost()
    default:
      return
    }
  }
  
  func queueDidRecieveElements<T>(_ queue: Queue<T>) {
    switch T.self {
    case is UUID.Type:
      fetchPost()
    case is PartialPost.Type:
      feedNextPostToTinderImageViewManager()
    default:
      return
    }
  }
  
}
