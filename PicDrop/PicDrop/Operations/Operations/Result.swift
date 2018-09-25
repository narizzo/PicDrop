//
//  Result.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/25/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

enum Result<Value, Error: Swift.Error> {
  case success(Value)
  case failure(Error)
}
