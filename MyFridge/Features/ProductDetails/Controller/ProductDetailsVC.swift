//
//  ProductDetailsVC.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 18/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import UIKit

class ProductDetailsVC: BaseVC {

    // MARK: Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var backButton: ButtonWithAnimate!
    @IBOutlet weak var moreButton: ButtonWithAnimate!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var shelfLifeLabel: LabelWithActions!
    @IBOutlet weak var barcodeImageView: UIImageView!
    
    // MARK: Constraints
    
    @IBOutlet weak var titleImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomOffset: NSLayoutConstraint!
    
    // MARK: Required Properties
    
    private var product: Product!
    
    // MARK: Properties
    
    private var lastContentOffset: CGFloat = 0
    
    // MARK: Computed properties
    
    override var navigationIsHidden: Bool {
        return true
    }
    
    // MARK: Instance
    
    static func instance(product: Product) -> ProductDetailsVC {
        let viewController = ProductDetailsVC.instance() as! ProductDetailsVC
        viewController.product = product
        
        return viewController
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        
        addObservers()
        updateContent()
    }
    
    override func viewDidLayoutSubviews() {
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 25)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        moreButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
    
    private func updateContent() {
        updateName()
        updateShelfLife()
        updateImages()
    }
    
    private func updateName() {
        nameField.text = product.name
        nameField.delegate = self
    }
    
    private func updateShelfLife() {
        shelfLifeLabel.cleanText()
        
        shelfLifeLabel.addText("от ")
        shelfLifeLabel.addAction(with: product.productionDate) {
            self.showSelectDateAlert(date: self.product.productionDate.date()) { (date) in
                self.product.setProductionDate(date)
                self.updateShelfLife()
            }
        }
        
        shelfLifeLabel.addText(" до ")
        shelfLifeLabel.addAction(with: product.shelfLifeEnd) {
            self.showSelectDateAlert(date: self.product.shelfLifeEnd.date()) { date in
                self.product.setShelfLifeEndDate(date)
                self.updateShelfLife()
            }
        }
    }
    
    private func updateImages() {
        titleImageView.setImage(for: product)

        barcodeImageView.image = EAN13Generator.generateImage(fromNumber: product.barcode, size: barcodeImageView.frame.size)
    }
    
    private func showSelectDateAlert(date: Date, _ action: @escaping DatePickerViewController.Action) {
        let alert = UIAlertController(style: .actionSheet, title: "Выберите дату")
        alert.addDatePicker(mode: .date, date: date, action: action)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    // MARK: Notifications
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboard = Keyboard(notification: notification) else { return }
        
        UIView.animate(with: keyboard) {
            self.scrollViewBottomOffset.constant = keyboard.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        guard let keyboard = Keyboard(notification: notification) else { return }
        
        UIView.animate(with: keyboard) {
            self.scrollViewBottomOffset.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Actions.
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet)
        
        let save = UIAlertAction(title: "Сохранить как шаблон", style: .default) { action in
            TemplatesManager.shared.createTemplate(with: self.product) { _ in }
        }
        let addImage = UIAlertAction(title: "Добавить фото", style: .default) { action in
            self.showImagePicker()
        }
        let delete = UIAlertAction(title: "Удалить", style: .destructive) { action in
            ProductsManager.shared.removeProduct(self.product) { [weak self] success in
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(save)
        alert.addAction(addImage)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Support.
    
    private func showImagePicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
}

// MARK: UITextFieldDelegate
extension ProductDetailsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let name = textField.text, name.count > 0 else {
            textField.text = product.name
            return
        }
        product.setName(name) 
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UIScrollViewDelegate
extension ProductDetailsVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        nameField.resignFirstResponder()
        
        let offset = scrollView.contentOffset.y
        
        if offset >= 0 {
            titleImageViewTopConstraint.constant = offset * 0.3
            contentViewTopConstraint.constant = (offset * 0.3 + 25) * -1
        }
        
        if offset <= 0 {
            titleImageHeightConstraint.constant = 320 + abs(offset)
            titleImageViewTopConstraint.constant = offset
        }
        
        view.layoutIfNeeded()
    }
    
}

// MARK: UIImagePickerControllerDelegate
extension ProductDetailsVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        titleImageView.addLoadingIndicator()
        
        product.addImage(image) { [weak self] _ in
            self?.updateImages()
        }
    }
    
}
