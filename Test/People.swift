//
//  People.swift
//  Test
//
//  Created by Gao on 2020/6/10.
//  Copyright © 2020 Gao. All rights reserved.
//

import UIKit

class People: NSObject {
    
    @objc
    class func test() {
        
        let dict: [String : Any] = [
            "nextActiveTime":"2020-06-29 14:50:00",
            "recurrence":[
                "interval":1,
                "type":0,
                "until":"2020-06-29 14:50:00"
            ],
            "reminders":[
                [
                    "nextActiveTime":"2020-06-29 14:50:00"
                ],
                [
                    "nextActiveTime":"2020-06-29 15:50:00"
                ]
            ]
            ]


        var item = dict
        
        if let reminders = dict["reminders"] as? [[String:Any]] {
             var newItems = [[String:Any]]()
             for item in reminders {
                 var tempItem = item
                 if let nextActiveTime = item["nextActiveTime"] as? String {
                     if nextActiveTime.hasPrefix("!!date") == false {
//                         if LKConfiguration.current()?.receiveUTCTime ?? false {
//                             tempItem["nextActiveTime"] = "!!date " + (nextActiveTime.currentToUTCDate ?? "")
//                         } else {
                             tempItem["nextActiveTime"] = "!!date " + nextActiveTime
//                         }
                     }
                 }
                 newItems.append(tempItem)
             }
             item["reminders"] = newItems
         }
        
        if var recurrence = item["recurrence"] as? [String:Any], let until = recurrence["until"] as? String {
            if until.hasPrefix("!!date") == false {
//                if LKConfiguration.current()?.receiveUTCTime ?? false {
//                    recurrence["until"] = "!!date " + (until.currentToUTCDate ?? "")
//                } else {
                    recurrence["until"] = "!!date " + until
//                }
                item["recurrence"] = recurrence
            }
        }
        
        if let nextActiveTime = item["nextActiveTime"] as? String {
                  if nextActiveTime.hasPrefix("!!date") == false {
//                      if LKConfiguration.current()?.receiveUTCTime ?? false {
//                          item["nextActiveTime"] = "!!date " + (nextActiveTime.currentToUTCDate ?? "")
//                      } else {
                          item["nextActiveTime"] = "!!date " + nextActiveTime
//                      }
                  }
              }
        
        print( NSDictionary(dictionary: item))
    }
    
    func myMin<T: Comparable>(_ a: T, _ b: T) -> T {
        return a < b ? a : b
    }
}
