//
//  EditSleep.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/13.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class EditSleep: Codable {
    var id:Int
    var sleep:String
    var deepSleep:String
    init(_ id:Int,_ sleep:String,_ deepSleep:String) {
        self.id = id
        self.sleep = sleep
        self.deepSleep = deepSleep
    }
}
