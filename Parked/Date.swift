//
//  Date.swift
//  Parked
//
//  Created by Mihaela Miches on 1/15/17.
//  Copyright © 2017 me. All rights reserved.
//

import Foundation

extension Date {
    public func minutesSince(date: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute, .second], from: self, to: date)
        
        if let _ = components.second {
            return abs(components.minute ?? 1)
        } else {
            return abs(components.minute ?? 0)
        }
    }
    
    public func elapsedSince(date: Date) -> String {
        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: self, to: date)
        var elapsed = ""
        
        elapsed += abs(difference.hour ?? 0) != 0 ? "\(abs(difference.hour!)) hours " : ""
        elapsed += abs(difference.minute ?? 0) != 0 ? "\(abs(difference.minute!)) min" : ""

        return elapsed
    }
    
    public func addDays(daysToAdd: Int) -> Date {
        return (Calendar.current.date(byAdding: DateComponents(day: daysToAdd), to: self) ?? self)
    }
    
    func toDisplayStyle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return self.dayOfWeek() + " at " + dateFormatter.string(from: self)
    }

    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self)
    }
}
