//
//  Notice.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/4/13.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation


class  Notice: Codable {

    var inviter :String?
    
    public init( _ inviter: String? ){
        self.inviter = inviter
    }
    
}
