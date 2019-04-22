//
//  EditBlood.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/9.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class EditBlood: Codable {
    var id:Int
    var bloodOxygen:Double
    init(_ id:Int,_ bloodOxygen:Double) {
        self.id = id
        self.bloodOxygen = bloodOxygen
    }
}
