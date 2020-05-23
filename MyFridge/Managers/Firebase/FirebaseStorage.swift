//
//  FirebaseStorage.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 23.05.2020.
//  Copyright © 2020 Maxim Vitovitsky. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

let IMAGE_LOADING_TAG = 16273

class FirebaseStorage {
    
    // MARK: - Static.
    
    static let shared = FirebaseStorage()
    
    static func configure() {
        FirebaseApp.configure()
    }
    
    
    // MARK: - Storage.
    
    let storage = Storage.storage()
    
    func getImage(for product: Product, completion: @escaping (UIImage?) -> Void) {
        let ref = storage.reference(withPath: "\(product.barcode).jpg")
        ref.getData(maxSize: 3096 * 3096) { data, error in
            guard let data = data, let image = UIImage(data: data) else {
                print("Get image for product (\(product.id), \(product.name)) error")
                completion(nil)
                return
            }

            completion(image)
        }
    }
    
    func saveImage(_ image: UIImage, for product: Product, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0) else { return }
        
        let ref = storage.reference(withPath: "\(product.barcode).jpg")
        
        ref.putData(imageData, metadata: nil) { storeData, error in
            guard storeData != nil, error == nil else {
                print("Save image for product (\(product.id), \(product.name)) error")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
}

extension UIImageView {
    
    func setImage(for product: Product) {
        let imageURL = "https://firebasestorage.googleapis.com/v0/b/myfridge-b9707.appspot.com/o/\(product.barcode).jpg?alt=media"
        
        addLoadingIndicator()
        sd_setImage(with: URL(string: imageURL)) { [weak self] image, _, _, _ in
            if image == nil {
                self?.image = UIImage(named: "crab")
            }
            self?.removeLoadingIndicator()
        }
    }
    
    func addLoadingIndicator() {
        guard viewWithTag(IMAGE_LOADING_TAG) == nil else { return }
        
        let view = UIView(frame: bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.tag = IMAGE_LOADING_TAG
        
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.startAnimating()
        indicator.center = view.center
        
        view.addSubview(indicator)
        addSubview(view)
    }
    
    func removeLoadingIndicator() {
        guard let loadingView = viewWithTag(IMAGE_LOADING_TAG) else { return }
        loadingView.removeFromSuperview()
    }
    
}
