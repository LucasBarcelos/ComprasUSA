//
//  Product+image.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 01/03/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import UIKit

extension Product {
    var image: UIImage? {
        return self.poster as? UIImage
    }
}

