//
//  ProductListTableViewController.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 28/02/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ProductListTableViewController: UITableViewController {

    // MARK: - Properties
    var fetchedResultsController: NSFetchedResultsController<Product>!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
        self.tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadProducts()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToEdit" {
            if let vc = segue.destination as? RegisterProduct {
                vc.product = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
            }
        }
    }

    // MARK: - Methods
    func emptyMessage(message:String? = nil, viewController:UITableViewController) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel
        if message != nil {
            viewController.tableView.separatorStyle = .none
        } else {
            viewController.tableView.separatorStyle = .singleLine
        }
    }
    
    private func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }
}

extension ProductListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        tableView.reloadData()
    }
}

extension ProductListTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController.fetchedObjects?.count ?? 0 > 0 {
            emptyMessage(viewController: self)
            return fetchedResultsController.fetchedObjects?.count ?? 0
        } else {
            emptyMessage(message: "Sua lista está vazia!", viewController: self)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        
        let product = fetchedResultsController.object(at: indexPath)
        
        cell.prepare(with: product)
        return cell
    }
}
