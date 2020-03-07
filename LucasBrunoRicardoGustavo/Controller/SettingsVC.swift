//
//  SettingsVC.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 29/02/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import UIKit
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
        loadStates()
        self.tableViewStates.delegate = self
        tableViewStates.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadStates()
    }

    // MARK: - Methods
    func showAlertForItem(_ item: State?) {
        let alert = UIAlertController(title: "Adicionar Estado", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textFieldState) in
            textFieldState.placeholder = "Nome do estado"
//            textField.text = item?.state
        }
        alert.addTextField { (textFieldTax) in
            textFieldTax.placeholder = "Imposto"
            textFieldTax.keyboardType = .decimalPad
//            textField.text = String(describing: item?.tax)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let addStateAction = UIAlertAction(title: "Adicionar", style: .default) { (_) in
            alert.textFields?.last?.text = alert.textFields?.last?.text?.replacingOccurrences(of: ",", with: ".")
            
            guard let name = alert.textFields?.first?.text,
            let tax = alert.textFields?.last?.text else { return }
            
            self.addState(stateName: name, tax: Double(tax) ?? 0)
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
