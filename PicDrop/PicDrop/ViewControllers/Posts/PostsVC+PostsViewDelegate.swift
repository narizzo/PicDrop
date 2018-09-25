//
//  PostsVC+PostsViewDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension PostsViewController: PostsViewDelegate {
  func postsViewTakePhoto(_ postsView: PostsView) {
    PresentTakePictureVcOperation(viewController: self, networkManager: networkManager).start()
    
    
    // make operations
    //let requestLocationOperation = RequestLocationWhenInUseOperation()
    
    //let presentTakePictureVcOperation = PresentTakePictureVcOperation(viewController: self, networkManager: networkManager)
    
    // set dependencies
//    presentTakePictureVcOperation.addDependency(requestLocationOperation)
//    operationQueue.addOperations([requestLocationOperation, presentTakePictureVcOperation], waitUntilFinished: false)
  }
}
