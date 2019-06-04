//
//  ButtonWithAnimate.swift
//  WebViewTest
//
//  Created by Georgiy Kronberg on 19/04/2019.
//  Copyright © 2019 Georgiy Kronberg. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ButtonWithAnimate: ColoredButton {
    
    open override func awakeFromNib() {
        setShadow()
        self.configureButtonActions()
    }
    
    func configureButtonActions() {
        self.addTarget(self, action: #selector(animateUp), for: .touchCancel)
        self.addTarget(self, action: #selector(animateUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(animateUp), for: .touchUpOutside)
        self.addTarget(self, action: #selector(animateDown), for: .touchDown)
    }
    
    @objc private func animateUp() {
        guard let _ = superview else {
            return
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
    }
    
    @objc private func animateDown() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: nil)
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if newValue < 0 {
                layer.cornerRadius = frame.height / 2
            } else {
                layer.cornerRadius = newValue
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var shadow : Bool = false
    
    private func setShadow() {
        if shadow {
            self.layer.setDefaultSketchShadow()
        }
    }
}

extension CALayer {
    
    func setSketchShadow(withColor color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    //change color for .cobalt in projects!
    
    func setDefaultSketchShadow(forColor color: UIColor = .black) {
        setSketchShadow(withColor: color, alpha: 0.2, x: 0, y: 6, blur: 12, spread: 0)
    }
}
