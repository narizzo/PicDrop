//
//  LocationDataProvider.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationDataProvider {
  var location: CLLocation? { get }
}
