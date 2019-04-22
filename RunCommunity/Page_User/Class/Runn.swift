//
//  Runn.swift
//  RunCommunity
//
//  Created by Joe on 2019/4/17.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class Runn: Codable {
    var id: Int
    var useraccount: String
    var time: String?
    var distance: String
    
    public init(_ id: Int, _ useraccount: String, _ time: String, _ distance: String) {
        self.id = id
        self.useraccount  = useraccount
        self.time = time
        self.distance = distance
    }
}
