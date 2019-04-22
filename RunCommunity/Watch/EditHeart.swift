//
//  EditHeart.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/5.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation
class EditHeart: Codable {
    var id:Int
    var heart:Double
    init(_ id:Int,_ heart:Double) {
    self.id = id
    self.heart = heart
    }
}
