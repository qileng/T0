//
//  DateInfo.swift
//  HALP
//
//  Created by 张秦龙 on 5/5/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

enum dt {
    case year;
    case month;
    case day;
    case hour;
    case minute;
    case second;
}

struct DateInfo {
    var year:Int = 0;
    var month:Int = 0;
    var day:Int = 0;
    var hour:Int = 0;
    var minute:Int = 0;
    var second:Int = 0;
    
    init() {
        self.year = 0;
        self.month = 0;
        self.day = 0;
        self.hour = 0;
        self.minute = 0;
        self.second = 0;
    }
    
    
    

}
