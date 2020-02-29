//
//  SettingsVC.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 29/02/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tfDollarExchangeRate: UITextField!
    @IBOutlet weak var tfIOFTax: UITextField!
    @IBOutlet weak var tableViewStates: UITableView!
    
    // MARK: - Properties
    var states: State!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Methods
    func showAlertForItem(_ item: State?) {
        let alert = UIAlertController(title: "Adicionar Estado", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do estado"
//            textField.text = item?.state
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Imposto"
//            textField.text = String(describing: item?.tax)
            textField.keyboardType = .decimalPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let addStateAction = UIAlertAction(title: "Adicionar", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text,
                let tax = alert.textFields?.last?.text else {return}
            
        }
        alert.addAction(addStateAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    @IBAction func btnAddState(_ sender: UIButton) {
        showAlertForItem(nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
