//
//  ProductTableViewCell.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 01/03/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import UIKit
import Foundation

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbProduct: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    func prepare(with product: Product) {
        ivPoster.image = product.image
        lbProduct.text = product.name
        lbPrice.text = "US$ \(product.price)"
    }

}
