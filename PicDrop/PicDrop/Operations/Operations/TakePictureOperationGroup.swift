//
//  TakePictureOperationGroup.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/25/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class TakePictureOperationGroup: OperationGroup {
  
  init(viewController: UIViewController, networkManager: NetworkManager) {
    super.init()
    
    let requestCameraAccessOp = RequestCameraAccessOperation()
    let requestLocationWhenInUseOp = RequestLocationWhenInUseOperation()
    
    let takePictureOp = TakePictureOperation(viewController: viewController)
    let locationOp = LocationOperation()
    
    requestLocationWhenInUseOp.addDependency(requestCameraAccessOp)
    takePictureOp.addDependency(requestLocationWhenInUseOp)
    locationOp.addDependency(takePictureOp)
    
    let operationGroup = OperationGroup()
    operationGroup.add(
      operations: [requestCameraAccessOp,
                   requestLocationWhenInUseOp,
                   takePictureOp,
                   locationOp])
    operationGroup.finishingOperation = BlockOperation { [weak networkManager] in
      let post = Post(uuid: UUID(), image: takePictureOp.image!, location: locationOp.location!)
      networkManager?.upload(post: post)
    }
  }
}
