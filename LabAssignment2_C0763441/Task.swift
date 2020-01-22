//
//  ViewController.swift
//  LabAssignment2_C0764930
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import Foundation

class Task{
    
    init(title: String, days: Int) {
        self.title = title
        self.days = days
        self.daysRequired = 1
    }
    
    var title: String
    var days: Int
    var daysRequired : Int
    var incrementer = 0
    
}
