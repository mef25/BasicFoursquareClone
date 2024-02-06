//
//  Singleton.swift
//  FoursquareClone
//
//  Created by Mehmet Emin Fırıncı on 5.02.2024.
//

import Foundation
import UIKit

class PlaceModel{
    
    static let sharedInstance = PlaceModel()
    
    var placename = ""
    var placetype = ""
    var placeatmosphere = ""
    var placeimage = UIImage()
    var longitude = Double()
    var latitude = Double()
    private init(){}
}
