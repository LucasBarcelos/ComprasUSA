//
//  StateTableViewCell.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 04/03/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import UIKit
import Foundation

class StateTableViewCell: UITableViewCell {

    @IBOutlet weak var lbStateName: UILabel!
    @IBOutlet weak var lbTax: UILabel!
    
    func prepare(with state: State) {
        lbStateName.text = state.state
        lbTax.text = "\(state.tax)"
    }
}
