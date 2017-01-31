//
//  Location.swift
//  Parked
//
//  Created by Mihaela Miches on 1/10/17.
//  Copyright © 2017 me. All rights reserved.
//

import CoreLocation

class Location: NSObject {
    static var shared = Location()
    var coreLocation: CLLocationManager
    var delegate: MapDelegate?
    
    override init() {
        coreLocation = CLLocationManager()
        super.init()
        coreLocation.delegate = self
        coreLocation.pausesLocationUpdatesAutomatically = true
        coreLocation.allowsBackgroundLocationUpdates = true
        coreLocation.activityType = CLActivityType.otherNavigation
    }
    
    //MARK:-
    func findCar(allTheThings:Bool=false, completion: @escaping (([Visit], ResponseKind) -> Void)) {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            return completion([], .needsPermissions)
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways  {
            return completion([], .locationDisabled)
        }
        
        coreLocation.requestLocation()
        Motion.queryRecentMotionActivities(days: (allTheThings ? 10 : 1)) { activities in
            guard let lastActivity = activities.last else { return completion([], .noMotionData) }
            
            guard Date().minutesSince(date: lastActivity.endDate) >= 0 else { return completion([], .driving) }
            
            let allLocations = CachedVisits.all().sorted{$0.0.startDate>$0.1.startDate}
            
            guard allLocations.count > 0 else { return completion([], .noLocationData)  }
            
            let possibleLocations = activities.reduce([], { (partial, activity) -> [Visit] in
                let parked = allLocations.filter {
                    $0.endDate == .distantFuture &&
                        (0...20~=activity.endDate.minutesSince(date: $0.startDate) ||
                        0...20~=activity.startDate.minutesSince(date: $0.startDate))
                    }.map { Visit(coordinate: $0.coordinate, startDate: activity.startDate, endDate: $0.startDate) }
                return parked.count > 0  ? partial + parked : partial
            }).sorted{$0.0.startDate>$0.1.startDate}
            
            guard let mostRecent = possibleLocations.first else { return completion([], .notFound) }
            
            if allTheThings {
                completion(possibleLocations, .manyFound)
            } else {
                completion([mostRecent], .found)
            }
        }
    }
    
    //MARK:-
    func start() {
        coreLocation.startMonitoringVisits()
    }
    
}

//MARK:- CLLocationManagerDelegate
extension Location: CLLocationManagerDelegate {
    func coreLocation(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) {
            coreLocation.requestLocation()
            coreLocation.startMonitoringVisits()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let allVisits = CachedVisits.all()
        let newVisit = Visit(coordinate: visit.coordinate, startDate: visit.arrivalDate == .distantPast ? Date() : visit.arrivalDate, endDate: visit.departureDate)
        let log = allVisits + [newVisit]
        // log = log.filter { $0.endDate < Calendar.current.date(byAdding: .day, value: -7, to: Date())! }
        CachedVisits.save(visits: Array(Set(log)))
        print("did visit", visit,"\n",log)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location manager ", manager, " did fail with ", error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdateLocation(currentLocation: locations.last)
    }
}
