//
//  UIViewController+Context.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 01/03/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
