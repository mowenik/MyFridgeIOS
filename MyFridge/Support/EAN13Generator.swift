import Foundation
import UIKit

struct EAN13Generator {
    
    fileprivate static let ean13LeftPartStructure = [
        "0": ["L", "L", "L", "L", "L", "L"],
        "1": ["L", "L", "G", "L", "G", "G"],
        "2": ["L", "L", "G", "G", "L", "G"],
        "3": ["L", "L", "G", "G", "G", "L"],
        "4": ["L", "G", "L", "L", "G", "G"],
        "5": ["L", "G", "G", "L", "L", "G"],
        "6": ["L", "G", "G", "G", "L", "L"],
        "7": ["L", "G", "L", "G", "L", "G"],
        "8": ["L", "G", "L", "G", "G", "L"],
        "9": ["L", "G", "G", "L", "G", "L"]
    ]
    
    // All right part of ean13 codes with R - code, so there is no need to build an array of right part structure as ean13LeftPartStructure
    fileprivate static let ean13RightPartCode = "R"
    
    fileprivate static let digitCodes = [
        "L": [
            "0": ["0", "0", "0", "1", "1", "0", "1"],
            "1": ["0", "0", "1", "1", "0", "0", "1"],
            "2": ["0", "0", "1", "0", "0", "1", "1"],
            "3": ["0", "1", "1", "1", "1", "0", "1"],
            "4": ["0", "1", "0", "0", "0", "1", "1"],
            "5": ["0", "1", "1", "0", "0", "0", "1"],
            "6": ["0", "1", "0", "1", "1", "1", "1"],
            "7": ["0", "1", "1", "1", "0", "1", "1"],
            "8": ["0", "1", "1", "0", "1", "1", "1"],
            "9": ["0", "0", "0", "1", "0", "1", "1"]
        ],
        "R": [
            "0": ["1", "1", "1", "0", "0", "1", "0"],
            "1": ["1", "1", "0", "0", "1", "1", "0"],
            "2": ["1", "1", "0", "1", "1", "0", "0"],
            "3": ["1", "0", "0", "0", "0", "1", "0"],
            "4": ["1", "0", "1", "1", "1", "0", "0"],
            "5": ["1", "0", "0", "1", "1", "1", "0"],
            "6": ["1", "0", "1", "0", "0", "0", "0"],
            "7": ["1", "0", "0", "0", "1", "0", "0"],
            "8": ["1", "0", "0", "1", "0", "0", "0"],
            "9": ["1", "1", "1", "0", "1", "0", "0"]
        ],
        "G": [
            "0": ["0", "1", "0", "0", "1", "1", "1"],
            "1": ["0", "1", "1", "0", "0", "1", "1"],
            "2": ["0", "0", "1", "1", "0", "1", "1"],
            "3": ["0", "1", "0", "0", "0", "0", "1"],
            "4": ["0", "0", "1", "1", "1", "0", "1"],
            "5": ["0", "1", "1", "1", "0", "0", "1"],
            "6": ["0", "0", "0", "0", "1", "0", "1"],
            "7": ["0", "0", "1", "0", "0", "0", "1"],
            "8": ["0", "0", "0", "1", "0", "0", "1"],
            "9": ["0", "0", "1", "0", "1", "1", "1"]
        ]
    ]
    
    static func generateImage(fromNumber code: String, size: CGSize = CGSize(width: 200, height: 100)) -> UIImage? {
        guard let view = generateView(fromNumber: code, size: size) else { return nil }
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
        static func generateImage(fromNumber code: Int64, size: CGSize = CGSize(width: 200, height: 100)) -> UIImage? {
        return generateImage(fromNumber: String(code), size: size)
    }
    
    static func generateView(fromNumber code: Int64, size: CGSize) -> UIView? {
        return generateView(fromNumber: String(code), size: size)
    }

    static func generateView(fromNumber code: String, size: CGSize) -> UIView? {
        
        // Single-character strings array, containing digits of barcode number
        let digitsArray = code.map { String($0) }

        guard isCorrectLength(ofCode: digitsArray)     else { return nil }
        guard isCorrectControlSum(ofCode: digitsArray) else { return nil }
        
        let barcodeView = UIView(frame: CGRect(origin: .zero, size: size))
        //Barcode consists of begining (3 stripes), left part (6 digits, 7 stripe each), middle (5 stripes), right part (6 digits, 7 stripes each) and end (3 stripes)
        let singleStripeWidth = size.width / (95)
        let leftPartCode = ean13LeftPartStructure[digitsArray[0]]!
        
        func stripeView(forIndex index: Int, shouldBeBlack: Bool) -> UIView {
            let view = UIView(frame: CGRect(x: singleStripeWidth * CGFloat(index),
                                            y: 0,
                                            width: singleStripeWidth,
                                            height: size.height))
            view.backgroundColor = shouldBeBlack ? .black : .white
            return view
        }
        
        //Begining - 3 stripes: 101 (1 - black, 0 - white)
        barcodeView.addSubview(stripeView(forIndex: 0, shouldBeBlack: true))
        barcodeView.addSubview(stripeView(forIndex: 1, shouldBeBlack: false))
        barcodeView.addSubview(stripeView(forIndex: 2, shouldBeBlack: true))
        
        //Left part of code - 6 digits (from 1 to 6), 7 stripes each
        // Offset for stripes: 3 (beginging)
        
        // digits
        for i in 1...6 {
            // stripes of digit
            for j in 0...6 {
                let colorDigit = digitCodes[leftPartCode[i - 1]]![digitsArray[i]]![j]
                barcodeView.addSubview(stripeView(forIndex: 3 + (i - 1) * 7 + j, shouldBeBlack: colorDigit == "1"))
            }
        }
        
        // Middle - 5 stripes: 01010 (1 - black, 0 - white)
        // Offset for stripes: 3 (beginging) + 6 * 7 (6 digits in left part, 7 stripes each)
        barcodeView.addSubview(stripeView(forIndex: 3 + 6 * 7 + 0, shouldBeBlack: false))
        barcodeView.addSubview(stripeView(forIndex: 3 + 6 * 7 + 1, shouldBeBlack: true))
        barcodeView.addSubview(stripeView(forIndex: 3 + 6 * 7 + 2, shouldBeBlack: false))
        barcodeView.addSubview(stripeView(forIndex: 3 + 6 * 7 + 3, shouldBeBlack: true))
        barcodeView.addSubview(stripeView(forIndex: 3 + 6 * 7 + 4, shouldBeBlack: false))
        
        //Right part of code - 6 digits (from 7 to 12), 7 stripes each
        // Offset for stripes: 3 (beginging) + 6 * 7 (6 digits in left part, 7 stripes each) + 5 (middle)
        // digits
        for i in 7...12 {
            // stripes of digit
            for j in 0...6 {
                let colorDigit = digitCodes[ean13RightPartCode]![digitsArray[i]]![j]
                barcodeView.addSubview(stripeView(forIndex: 3 + 6 * 7 + 5 + (i - 7) * 7 + j, shouldBeBlack: colorDigit == "1"))
            }
        }
        
        //End - 3 stripes: 101 (1 - black, 0 - white)
        // Offset for stripes: 3 (beginging) + 6 * 7 (6 digits in left part, 7 stripes each) + 5 (middle) + 6 * 7 (6 digits in left part, 7 stripes each)
        barcodeView.addSubview(stripeView(forIndex: 3 + 6 * 7 + 5 + 6 * 7 + 0, shouldBeBlack: true))
        barcodeView.addSubview(stripeView(forIndex: 3 + 6 * 7 + 5 + 6 * 7 + 1, shouldBeBlack: false))
        barcodeView.addSubview(stripeView(forIndex: 3 + 6 * 7 + 5 + 6 * 7 + 2, shouldBeBlack: true))
        
        return barcodeView
    }
    
    fileprivate static func isCorrectLength(ofCode digitsArray: [String]) -> Bool {
        if digitsArray.count != 13 {
            print("Incorrect length of code")
            return false
        } else {
            return true
        }
    }
    
    fileprivate static func isCorrectControlSum(ofCode digitsArray: [String]) -> Bool {
        var oddSum = 0
        var evenSum = 0
        for i in 0..<13 {
            if let digit = Int(digitsArray[i]) {
                // odd and even are inverted, because of start index is 0
                if i % 2 == 0 {
                    oddSum += digit
                } else {
                    evenSum += digit
                }
            } else {
                print("Barcode number string contains not only digits")
                return false
            }
        }
        if (evenSum * 3 + oddSum) % 10 != 0 {
            print("Incorrect control sum")
            return false
        } else {
            return true
        }
    }
    
}
