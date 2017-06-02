//
//  TodoList.swift
//  LocalNotification
//
//  Created by Rui Mao on 5/31/17.
//  Copyright © 2017 Rui Mao. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class TodoList {
    class var sharedInstance : TodoList {
        struct Static {
            static let instance: TodoList = TodoList()
        }
        return Static.instance
    }
    
    fileprivate let ITEMS_KEY = "todoItems"
    func addItem(_ item: TodoItem) {
        // persist a representation of this todo item in UserDefaults
        var todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        UserDefaults.standard.set(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        //let notification = UNNotificationRequest()
        content.body = "Todo Item \"\(item.title)\" Is Overdue" // text that will be displayed in the notification
        content.sound = UNNotificationSound.default()
        content.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        let deadline = item.deadline
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: deadline)
        let hour = calendar.component(.hour, from: deadline)
        let day = calendar.component(.day, from: deadline)
        let month = calendar.component(.month, from: deadline)
        let year = calendar.component(.year, from:deadline)
      
        var dateComponents = DateComponents()
        dateComponents.minute = minute
        dateComponents.hour = hour
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func removeItem(_ item: TodoItem) {
        let application = UIApplication.shared
        let scheduledNotifications = application.scheduledLocalNotifications!
        
        //let scheduledNotifications: [UNNotificationRequest]? = UIApplication.sharedApplication().scheduledLocalNotifications
        //guard scheduledNotifications != nil else {return} // Nothing to remove, so return
        
        for notification in scheduledNotifications { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched
                UIApplication.shared.cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
        
        if var todoItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
            todoItems.removeValue(forKey: item.UUID)
            UserDefaults.standard.set(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
    }
    
    func allItems () -> [TodoItem] {
        let todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map({
            let item = $0 as! [String:AnyObject]
            return TodoItem(deadline: item["deadline"] as! Date, title: item["title"] as! String, UUID: item["UUID"] as! String)}).sorted(by: { (left: TodoItem, right: TodoItem) -> Bool in
                (left.deadline.compare(right.deadline) == .orderedAscending)
        })
    }
    }
