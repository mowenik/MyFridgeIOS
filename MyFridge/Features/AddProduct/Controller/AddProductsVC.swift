//
//  NewProductsVC.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 18/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddProductsVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    
    private var unsavedProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellReuseID: NewProductTableCell.reuseID)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 100, right: 0)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    func updateData() {
        tableView.reloadData()
        setPlaceholderHidden(unsavedProducts.count != 0)
    }
    
    func setPlaceholderHidden(_ isHidden: Bool) {
        if placeholderView.isHidden == isHidden { return }
        
        UIView.animate(withDuration: 0.5) {
            self.placeholderView.alpha = isHidden ? 0 : 1
            self.placeholderView.isHidden = isHidden
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let controller = ScannerVC()
        controller.delegate = self
        
        Router.show(controller: controller, inNavigation: false)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ProductsManager.shared.saveProducts(unsavedProducts) { [weak self] success in
            guard let self = self else { return }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if success {
                self.unsavedProducts = []
                self.tabBarController?.selectedIndex = 0
            } else {
                self.showAlert(text: "Произошла ошибка при сохранении продуктов")
            }
            
            self.updateData()
        }
    }
    
}

extension AddProductsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unsavedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewProductTableCell.reuseID) as! NewProductTableCell
        let product = unsavedProducts[indexPath.row]
        
        cell.setup(withProduct: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            unsavedProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            setPlaceholderHidden(unsavedProducts.count != 0)
        }
    }
    
}

extension AddProductsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = unsavedProducts[indexPath.row]
        Router.show(controller: ProductDetailsVC.instance(product: product))
    }
    
}

extension AddProductsVC: ScannerVCDelegate {
    
    func didScanBarcode(_ barcode: String) {
        let product = ProductsManager.shared.createProduct(with: barcode)
        
        self.unsavedProducts.append(product)
        self.setPlaceholderHidden(!self.unsavedProducts.isEmpty)
        self.tableView.reloadData()
    }
    
}
