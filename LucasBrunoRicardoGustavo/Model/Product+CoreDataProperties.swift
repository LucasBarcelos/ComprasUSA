//
//  Product+CoreDataProperties.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Gustavo Caspirro on 05/03/20.
//  Copyright © 2020 Gustavo Caspirro. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var card: Bool
    @NSManaged public var name: String?
    @NSManaged public var poster: NSObject?
    @NSManaged public var price: Double
    @NSManaged public var state: State?

}
