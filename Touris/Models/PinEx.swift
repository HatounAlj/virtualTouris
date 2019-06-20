//
//  PinEx.swift
//  Touris
//
//  Created by Eng.Hatoun 👩🏻‍💻 on 12/10/1440 AH.
//  Copyright © 1440 Eng.Hatoun 👩🏻‍💻. All rights reserved.
//

import UIKit
import MapKit
import Foundation

extension Pin {
    var coordinates: CLLocationCoordinate2D {
        set {
            lat = newValue.latitude
            long = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }

    func compare(to Coordiate: CLLocationCoordinate2D)-> Bool{
        return (lat == Coordiate.latitude && long == Coordiate.longitude)
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        date = Date()
    }
}
