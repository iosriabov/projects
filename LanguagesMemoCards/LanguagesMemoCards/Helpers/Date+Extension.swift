//
//  Date+Extension.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 03.04.2022.
//

import Foundation

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var minuteAfter: Date {
        return Calendar.current.date(byAdding: .minute, value: 1, to: self)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
