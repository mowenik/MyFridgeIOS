//
//  NewProductTableCell.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 18/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import UIKit

class NewProductTableCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productionDateLabel: UILabel!
    @IBOutlet weak var shelfLifeEndLabel: UILabel!
    
    func setup(withProduct product: Product) {
        selectionStyle = .none
        
        productImageView.image = product.images.last
        nameLabel.text = product.name
        productionDateLabel.text = "Произведен – \(product.productionDate)"
        shelfLifeEndLabel.text = "Годен до – \(product.shelfLifeEnd)"
    }
    
}
