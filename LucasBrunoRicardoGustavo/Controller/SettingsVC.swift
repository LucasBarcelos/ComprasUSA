//
//  SettingsVC.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 29/02/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SettingsVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tfDollarExchangeRate: UITextField!
    @IBOutlet weak var tfIOFTax: UITextField!
    @IBOutlet weak var tableViewStates: UITableView!
    
    // MARK: - Properties
    var fetchedResultsController: NSFetchedResultsController<State>!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        loadStates()
        self.tableViewStates.delegate = self
        self.tfDollarExchangeRate.delegate = self
        self.tfIOFTax.delegate = self
        tableViewStates.tableFooterView = UIView(frame: CGRect.zero)
        registerSettingsBundle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadStates()
        self.tfIOFTax.text = SettingsBundleHelper.getSettingsBundleValues(identifier: "IOF")
        self.tfDollarExchangeRate.text = SettingsBundleHelper.getSettingsBundleValues(identifier: "Dolar")
    }

    // MARK: - Methods
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func showAlertForItem(_ item: State?, index: Int? = nil) {
        
        var title: String
        
        if item != nil {
            title = "Editar"
        } else {
            title = "Adicionar"
        }
        let alert = UIAlertController(title: "\(title) Estado", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textFieldState) in
            
            if item != nil {
                textFieldState.text = item?.state
            } else {
                textFieldState.placeholder = "Nome do estado"
            }
            
        }
        
        alert.addTextField { (textFieldTax) in
            textFieldTax.keyboardType = .decimalPad
            
            if item != nil {
                guard let state = item else { return }
                textFieldTax.text = "\(state.tax)"
            } else {
                textFieldTax.placeholder = "Imposto"
            }

        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let addStateAction = UIAlertAction(title: "\(title)", style: .default) { (_) in
            alert.textFields?.last?.text = alert.textFields?.last?.text?.replacingOccurrences(of: ",", with: ".")
            
            guard let name = alert.textFields?.first?.text,
            let tax = alert.textFields?.last?.text else { return }
            
            if item != nil {
                self.updateStateCoreData(index: index ?? 0, taxValue: tax, stateName: name)
            } else {
                self.addState(stateName: name, tax: Double(tax) ?? 0)
            }
        }
        alert.addAction(addStateAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addState(stateName: String, tax: Double) {
        if stateName != "" {
            let states = State(context: context)
            states.state = stateName
            states.tax = tax
            self.context.insert(states)
            try? context.save()
            tableViewStates.reloadData()
        } else {
            let alert = UIAlertController(title: "Atenção", message: "Você precisa preencher todos os campos para poder concluir o cadastro!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Entendi", style: .default, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "state", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        tableViewStates.reloadData()
    }
    
    private func updateStateCoreData(index: Int, taxValue: String, stateName: String) {
        guard let states = fetchedResultsController.fetchedObjects else { return }
        
        let updateState = states[index]
        
        updateState.setValue(stateName, forKey: "state")
        updateState.setValue(Double(taxValue), forKey: "tax")
        try? context.save()

        loadStates()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Actions
    @IBAction func btnAddState(_ sender: UIButton) {
        showAlertForItem(nil)
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as! StateTableViewCell

        let state = fetchedResultsController.object(at: indexPath)

        cell.prepare(with: state)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = fetchedResultsController.object(at: indexPath)
        
        showAlertForItem(state, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let state = fetchedResultsController.object(at: indexPath)
            context.delete(state)
            try? context.save()
            loadStates()
        }
    }
}

extension SettingsVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        tableViewStates.reloadData()
    }
}

extension SettingsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.text = textField.text?.replacingOccurrences(of: ",", with: ".")
        
        if textField == tfDollarExchangeRate {
            SettingsBundleHelper.setApplicationDefault(defaultKey: "Dolar", value: textField.text ?? "")
        } else if textField == tfIOFTax {
            SettingsBundleHelper.setApplicationDefault(defaultKey: "IOF", value: textField.text ?? "")
        }
    }
}
