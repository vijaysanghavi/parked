//
//  Visit.swift
//  Parked
//
//  Created by Mihaela Miches on 1/15/17.
//  Copyright © 2017 me. All rights reserved.
//

import CoreLocation
import MapKit

class Visit: NSObject, NSCoding {
    let coordinate: CLLocationCoordinate2D
    let startDate: Date
    let endDate: Date
    
    init(coordinate: CLLocationCoordinate2D, startDate: Date, endDate: Date) {
        self.coordinate = coordinate
        self.startDate = startDate
        self.endDate = endDate
    }
    
    required init?(coder aDecoder: NSCoder) {
        let long = aDecoder.decodeDouble(forKey: "long")
        let lat = aDecoder.decodeDouble(forKey: "lat")
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        guard let startDate = aDecoder.decodeObject(forKey: "startDate") as? Date,
            let endDate = aDecoder.decodeObject(forKey: "endDate") as? Date else {return nil}
        
        self.coordinate = coordinate
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(coordinate.longitude, forKey: "long")
        aCoder.encode(coordinate.latitude, forKey: "lat")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(endDate, forKey: "endDate")
    }
}

extension Visit: MKAnnotation {
    var title: String? {
        return endDate.toDisplayStyle()
    }
    
    var subtitle: String? {
        return endDate.elapsedSince(date: startDate) + " drive"
    }
}
