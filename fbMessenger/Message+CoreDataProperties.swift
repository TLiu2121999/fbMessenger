//
//  Message+CoreDataProperties.swift
//  fbMessenger
//
//  Created by Tongtong Liu on 7/5/18.
//  Copyright © 2018 Tongtong Liu. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var isSender: NSNumber?
    @NSManaged public var friend: Friend?

}
