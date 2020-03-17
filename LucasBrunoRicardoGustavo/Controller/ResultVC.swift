//
//  ResultVC.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Bruno Luiz Caetano dos Santos on 17/03/20.
//  Copyright © 2020 Bruno Luiz Caetano dos Santos. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ResultVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblTotalDollar: UILabel!
    @IBOutlet weak var lblTotalReal: UILabel!
    
    // MARK: - Properties
    var fetchedResultsController: NSFetchedResultsController<Product>!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadProducts()
        calculate()
    }
    
    // MARK: - Methods
    private func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    
    private func calculate() {
        guard let products = fetchedResultsController.fetchedObjects,
            let iof = SettingsBundleHelper.getSettingsBundleValues(identifier: "IOF"),
            let dollar = SettingsBundleHelper.getSettingsBundleValues(identifier: "Dolar") else { return }
        var totalDollar: Double = 0.0
        var totalRealWithTax: Double = 0.0
        
        for product in products {
            totalDollar = totalDollar + product.price
            
            if product.card {
                totalRealWithTax = totalRealWithTax + ((product.price * (Double(iof) ?? 0.0)) / 100.0)
                totalRealWithTax = totalRealWithTax + ((product.price * (product.state?.tax ?? 0.0)) / 100.0)
                totalRealWithTax = totalRealWithTax + (product.price * (Double(dollar) ?? 0.0))
            } else {
                totalRealWithTax = totalRealWithTax + ((product.price * (product.state?.tax ?? 0.0)) / 100.0)
                totalRealWithTax = totalRealWithTax + (product.price * (Double(dollar) ?? 0.0))
            }
        }
        lblTotalReal.text = String(format:"%.2f", totalRealWithTax)
        lblTotalDollar.text = String(format:"%.2f", totalDollar)
    }
}

extension ResultVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
}
