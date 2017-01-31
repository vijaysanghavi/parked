
//
//  Motion.swift
//  Parked
//
//  Created by Mihaela Miches on 1/14/17.
//  Copyright © 2017 me. All rights reserved.
//

import CoreMotion
import CoreLocation

struct MotionActivity {
    let startDate: Date
    let endDate: Date
    let type: MotionActivityType
}

struct Motion {
    static func queryRecentMotionActivities(days: Int = 1, completion: @escaping (([MotionActivity]) -> Void)) {
        let coreMotionActivity = CMMotionActivityManager()
        let coreMotionQueue = OperationQueue()
        let end = Date()
        let start = end.addDays(daysToAdd: -days)
        
        coreMotionActivity.queryActivityStarting(from: start, to: end, to: coreMotionQueue) { (activities, error) in
            guard let activities = activities, error == nil else {  print("no motion data :/", error ?? ""); return  completion([])}
            
            let motions = activities.filter { $0.confidence == .high }
                .map { ($0.startDate, MotionActivityType(activity: $0)) }
                .filter { $0.1 != nil && ($0.1! == MotionActivityType.automotive || $0.1! == MotionActivityType.cycling) }
                .map { MotionActivity(startDate: $0.0, endDate: $0.0, type: $0.1!) }
            
            let rides = motions.sorted { $0.0.startDate.timeIntervalSince1970 < $0.1.startDate.timeIntervalSince1970 }.reduce([], { (partial, next) -> [MotionActivity] in
                guard let last = partial.last else { return [next] }
                
                if 0...10~=next.endDate.minutesSince(date: last.endDate) {
                    return partial.dropLast() + [MotionActivity(startDate: last.startDate, endDate: next.endDate, type: last.type)]
                } else {
                    return partial + [next]
                }
            })
 
            completion(rides)
        }
    }
}




