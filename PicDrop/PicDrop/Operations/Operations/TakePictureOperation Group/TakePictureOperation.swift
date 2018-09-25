//
//  TakePictureOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/21/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class TakePictureOperation: AsynchronousOperation, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  weak var viewController: UIViewController?
  var image: UIImage?
  
  init(viewController: UIViewController) {
    self.viewController = viewController
    print("TakePicture Operation init")
  }
  
  private lazy var imagePicker: UIImagePickerController = {
    let ip = UIImagePickerController()
    ip.delegate = self
    ip.sourceType = .camera
    ip.cameraFlashMode = .off
    ip.allowsEditing = false
    return ip
  }()
  
  override func main() {
    DispatchQueue.main.async {
      self.viewController?.present(self.imagePicker, animated: true, completion: nil)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    viewController?.dismiss(animated: true, completion: nil)
    finish()
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    image = info[UIImagePickerControllerOriginalImage] as? UIImage
    viewController?.dismiss(animated: true, completion: nil)
    finish()
  }
  
}





//    if UIImagePickerController.isSourceTypeAvailable(.camera) {
//      imagePicker.delegate = self
//      imagePicker.sourceType = .camera;
//      imagePicker.cameraFlashMode = .off
//      imagePicker.allowsEditing = false
//
//      self.present(imagePicker, animated: true, completion: nil)
//    } else {
//      alertUserNoCamera()
//    }
