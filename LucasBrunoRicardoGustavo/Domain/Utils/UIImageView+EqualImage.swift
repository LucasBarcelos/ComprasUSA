//
//  UIImage+EqualImage.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 04/03/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    func isEqualToImage(_ image: UIImage) -> Bool {
        return self.pngData() == image.pngData()
    }

}
