//
//  DateExtensions.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/27/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation

extension Date {
    static func from(_ ISOString: String) -> Date? {
        let formatter = DateFormatter()
        
        // Format 1
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: ISOString) {
            return parsedDate
        }
        
        // Format 2
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from: ISOString) {
            return parsedDate
        }
        
        // Couldn't parsed with any format. Just get the date
        let splitedDate = ISOString.components(separatedBy: "T")
        if splitedDate.count > 0 {
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsedDate = formatter.date(from: splitedDate[0]) {
                return parsedDate
            }
        }
        return nil
    }
}
