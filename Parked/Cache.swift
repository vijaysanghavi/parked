//
//  Cache.swift
//  Parked
//
//  Created by Mihaela Miches on 1/14/17.
//  Copyright © 2017 me. All rights reserved.
//

import CoreLocation

struct CachedVisits {
    static let cacheKey = "recent-visits"
    
    static func all() -> [Visit] {
        guard let data = UserDefaults.standard.data(forKey: cacheKey),
            let visits = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Visit]
            else { return [] }
        
        return visits
    }
    
    static func save(visits: [Visit]) {
//        let ended = visits.filter {$0.endDate != .distantFuture }
//        let visiting = visits.filter {$0.endDate == .distantFuture }
//        
//        var cached = ended + visiting.filter { visit in
//               !ended.map{($0.coordinate, $0.startDate)}.contains {$0.0 == visit.coordinate && $0.1.timeIntervalSince1970 == visit.startDate.timeIntervalSince1970}
//            }
//        
//        cached = Array(Set(cached))
        
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: visits), forKey: cacheKey )
    }
    
    static func add(visit: Visit) {
        save(visits: CachedVisits.all() + [visit])
    }
    
    static func clear() {
        UserDefaults.standard.set([], forKey: cacheKey)
    }
}
