//
//  Date.swift
//  Voyce
//
//  Created by Tyler Luk on 4/12/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation

extension Date{
    
    //returns the date of the post as a String (e.g. "March 22, 2020)
    func dateAsString(postDate:String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let showDate = inputFormatter.date(from: postDate)
        inputFormatter.dateFormat = "MMMM d, yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    //converts original post date format to a time format without Z
    func convertToTimeFormat(postDate:String)->String{
         let inputFormatter2 = DateFormatter()
        inputFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let showDate2 = inputFormatter2.date(from:postDate)
        inputFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let resultString2 = inputFormatter2.string(from: showDate2!)
        return resultString2
    }
    
    //returns time since a date
    //adapted this code from a user on stackoverflow (https://stackoverflow.com/questions/44086555/swift-display-time-ago-from-date-nsdate)
    //can change the output if wanted
    func timeSincePost(timeAgo:String) -> String
          {
              let df = DateFormatter()

              df.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let dateWithTime = df.date(from: timeAgo)

              let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateWithTime!, to: Date())

              if let year = interval.year, year > 0 {
                  return year == 1 ? "\(year)" + " " + "year ago" : "\(year)" + " " + "years ago"
              } else if let month = interval.month, month > 0 {
                  return month == 1 ? "\(month)" + " " + "month ago" : "\(month)" + " " + "months ago"
              } else if let day = interval.day, day > 0 {
                  return day == 1 ? "\(day)" + " " + "day ago" : "\(day)" + " " + "days ago"
              }else if let hour = interval.hour, hour > 0 {
                  return hour == 1 ? "\(hour)" + " " + "hour ago" : "\(hour)" + " " + "hours ago"
              }else if let minute = interval.minute, minute > 0 {
                  return minute == 1 ? "\(minute)" + " " + "minute ago" : "\(minute)" + " " + "minutes ago"
              }else if let second = interval.second, second > 0 {
                  return second == 1 ? "\(second)" + " " + "second ago" : "\(second)" + " " + "seconds ago"
              } else {
                  return "a moment ago"
              }
          }
    
}
