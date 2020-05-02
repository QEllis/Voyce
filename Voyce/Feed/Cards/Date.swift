//
//  Date.swift
//  Voyce
//
//  Created by Tyler Luk on 4/12/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation

extension Date {
    
    /// Returns the date of the post as a String (e.g. "March 22, 2020)
    func dateAsString(postDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let showDate = inputFormatter.date(from: postDate)
        inputFormatter.dateFormat = "MMMM d, yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    /// Converts original post date format to a time format without Z.
    func convertToTimeFormat(postDate: String) -> String {
        let inputFormatter2 = DateFormatter()
        inputFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let showDate2 = inputFormatter2.date(from:postDate)
        inputFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let resultString2 = inputFormatter2.string(from: showDate2!)
        return resultString2
    }
    
    /// Returns time since a date.
    /// Adapted this code from a user on stackoverflow (https://stackoverflow.com/questions/44086555/swift-display-time-ago-from-date-nsdate)
    
    /// Can change the output if wanted.
    func timeSincePost(timeAgo: String) -> String {
        let df = DateFormatter()
        
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateWithTime = df.date(from: timeAgo)
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateWithTime!, to: Date())
        
        if let day = interval.day, day > 7 {
            return ""//return month == 1 ? "\(month)" + " " + "month ago" : "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day >= 1 ? "\(day)" + " " + "days ago" : "\(day)" + " " + "day ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hours ago" : "\(hour)" + " " + "hour ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minutes ago" : "\(minute)" + " " + "minute ago"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "seconds ago" : "\(second)" + " " + "second ago"
        } else {
            return "a moment ago"
        }
    }
}
