//
//  Plan+CoreDataProperties.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/3/8.
//  Copyright © 2019 PIG. All rights reserved.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var duration: Int16
    @NSManaged public var distance: Int16

}
