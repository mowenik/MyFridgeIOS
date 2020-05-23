//
//  GroupVC.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 24.05.2020.
//  Copyright © 2020 Maxim Vitovitsky. All rights reserved.
//

import UIKit

class GroupVC: BaseVC {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(copyAction))
        codeLabel.isUserInteractionEnabled = true
        codeLabel.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        codeLabel.text = GroupManager.shared.groupID
        codeField.placeholder = GroupManager.shared.groupID
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let text = GroupManager.shared.groupID

        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        guard let text = codeField.text, text.count == 8 else {
            showAlert(text: "Код должен состоять из восьми цифр")
            return
        }
        
        GroupManager.shared.groupID = codeField.text ?? GroupManager.shared.groupID
        
        ProductsManager.shared.updateProducts { _ in }
        TemplatesManager.shared.updateTemplates()
        
        tabBarController?.selectedIndex = 0
    }
    
    @objc private func copyAction() {
        showAlert(text: "Код скопирован!")
        UIPasteboard.general.string = GroupManager.shared.groupID
    }
    
}

extension UIViewController {
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
    
}
