//
//  TodoItem.swift
//  LocalNotification
//
//  Created by Rui Mao on 5/31/17.
//  Copyright © 2017 Rui Mao. All rights reserved.
//

import Foundation

struct TodoItem {
    var title: String
    var deadline: Date
    var UUID: String
    
    init(deadline: Date, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return(Date().compare(self.deadline) == ComparisonResult.orderedDescending)
    }
    
    
}
