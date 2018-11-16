//
//  Todos+CoreDataProperties.swift
//  CoreData Sample
//
//  Created by Win Than Htike on 11/16/18.
//  Copyright © 2018 PADC. All rights reserved.
//
//

import Foundation
import CoreData


extension Todos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todos> {
        return NSFetchRequest<Todos>(entityName: "Todos")
    }

    @NSManaged public var name: String?

}
