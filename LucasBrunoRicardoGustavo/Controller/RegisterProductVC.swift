//
//  RegisterProduct.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 29/02/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class RegisterProduct: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var imgButton: UIButton!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var switchCreditCard: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnRegister: UIButton!
    
    // MARK: - Properties
    var product: Product?
    var fetchedResultsController: NSFetchedResultsController<State>?
    let notificationCenter = NotificationCenter.default
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.tfProductName.delegate = self
        self.tfPrice.delegate = self
        loadStates()
        createPickerView()
        registerNotifications()
        validateEditing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadStates()
    }
    
    // MARK: - Methods
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func registerNotifications() {
        self.notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func validateEditing() {
        if product != nil {
            
            guard let prod = product else { return }
            
            self.tfProductName.text = prod.name
            self.imgPoster.image = prod.image
            self.tfState.text = self.product?.state?.state
            self.tfPrice.text = "\(prod.price)"
            self.btnRegister.setTitle("ALTERAR", for: .normal)
            self.navigationItem.title = "Editar Cadastro"
            
            if prod.card {
                self.switchCreditCard.isOn = true
            } else {
                self.switchCreditCard.isOn = false
            }
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
             scrollView.contentInset = .zero
        } else {
             scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    private func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "state", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController?.delegate = self
        
        try? fetchedResultsController?.performFetch()
    }
    
    func insertData() {
        guard let imgPoster = imgPoster.image,
            let states = fetchedResultsController?.fetchedObjects else { return }
        
        self.tfPrice.text = tfPrice.text?.replacingOccurrences(of: ",", with: ".")
        let aux = Double(self.tfPrice.text!) ?? 0.0
        
        if tfProductName.text != "" && !imgPoster.isEqualToImage(#imageLiteral(resourceName: "img_placeholder"))
            && tfState.text != "" && tfPrice.text != ""  {
            
            if aux < 0.01 {
                let alert = UIAlertController(title: "Atenção", message: "O valor do produto deve ser maior ou igual a 1 centavo!", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Entendi", style: .default, handler: nil)
                
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else {
                if product == nil {
                    product = Product(context: context)
                }
                
                guard let product = product else { return }
                
                product.name = tfProductName.text
                product.poster = imgPoster
                tfPrice.text = tfPrice.text?.replacingOccurrences(of: ",", with: ".")
                product.price = Double(tfPrice.text!) ?? 0
                product.card = switchCreditCard.isOn
                
                for state in states {
                    if state.state == tfState.text {
                        state.addToProducts(product)
                        self.context.insert(product)
                        try? context.save()
                    }
                }
                
                try? context.save()
            }

        } else {
            let alert = UIAlertController(title: "Atenção", message: "Você precisa preencher todos os campos para poder concluir o cadastro!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Entendi", style: .default, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Actions
    @IBAction func imgButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você desejar escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (_) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (_) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchCreditCard(_ sender: UISwitch) {
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        self.insertData()
    }
}

extension RegisterProduct: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            let aspectRatio = image.size.width / image.size.height
            let maxSize: CGFloat = 500
            var smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: maxSize, height: maxSize/aspectRatio)
            } else {
                smallSize = CGSize(width: maxSize*aspectRatio, height: maxSize)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            imgPoster.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}

extension RegisterProduct: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterProduct: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fetchedResultsController?.fetchedObjects?[row].state
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfState.text = fetchedResultsController?.fetchedObjects?[row].state
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        self.tfState.inputView = pickerView
        dismissPickerView()
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.tfState.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
}

extension RegisterProduct: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
}
