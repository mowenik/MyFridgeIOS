//
//  ProductCollectionCell.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 17/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var shelfLifeLabel: UILabel!
    
    override func prepareForReuse() {
        productImage.image = nil
        productName.text = nil
    }
    
    func setup(withProduct product: Product) {
        productImage.setImage(for: product)
        
        productName.text = product.name
        shelfLifeLabel.text = "до \(product.shelfLifeEnd)"
    }
    
}
