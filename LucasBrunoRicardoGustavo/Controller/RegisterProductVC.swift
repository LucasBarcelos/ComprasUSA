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
    
    // MARK: - Properties
    var product: Product?
    let notificationCenter = NotificationCenter.default
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.tfProductName.delegate = self
        self.tfState.delegate = self
        self.tfPrice.delegate = self
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Navigation
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
    
    @IBAction func btnAddStates(_ sender: UIButton) {
    }
    
    @IBAction func switchCreditCard(_ sender: UISwitch) {
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        if tfProductName.text != "" && !imgPoster.isEqual(UIImage(named: "img_placeholder")) && tfState.text != "" && tfPrice.text != "" {
            if product == nil {
                product = Product(context: context)
            }
            
            product?.name = tfProductName.text
            product?.poster = imgPoster.image
            product?.owner?.state = tfState.text
            tfPrice.text = tfPrice.text?.replacingOccurrences(of: ",", with: ".")
            product?.price = Double(tfPrice.text!) ?? 0
            product?.card = switchCreditCard.isOn
        
            try? context.save()
        } else {
            let alert = UIAlertController(title: "Atenção", message: "Você precisa preencher todos os campos para poder concluir o cadastro!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Entendi", style: .default, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
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
