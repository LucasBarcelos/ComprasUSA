//
//  State+CoreDataProperties.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Gustavo Caspirro on 05/03/20.
//  Copyright © 2020 Gustavo Caspirro. All rights reserved.
//
//

import Foundation
import CoreData


extension State {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State")
    }

    @NSManaged public var state: String?
    @NSManaged public var tax: Double
    @NSManaged public var products: Set<Product>

}

// MARK: Generated accessors for products
extension State {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
