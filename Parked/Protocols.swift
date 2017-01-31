//
//  Protocols.swift
//  Parked
//
//  Created by Mihaela Miches on 1/14/17.
//  Copyright © 2017 me. All rights reserved.
//

import CoreLocation
import CoreMotion

protocol SearchResponse {}

protocol MapDelegate {
    func didUpdateLocation(currentLocation: CLLocation?)
}

enum ResponseKind: SearchResponse {
    case needsPermissions, locationDisabled
    case found, notFound, manyFound
    case noLocationData, noMotionData, driving
}

enum MotionActivityType {
    case stationary, walking, running, cycling, automotive
    init?(activity: CMMotionActivity) {
        if activity.automotive {
            self = .automotive
        } else if activity.running {
            self = .running
        } else if activity.walking {
            self = .walking
        } else if activity.cycling {
            self = .cycling
        } else if activity.stationary {
            self = .stationary
        } else {
            return nil
        }
    }
}

func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.longitude == rhs.longitude && lhs.latitude == lhs.latitude
}
