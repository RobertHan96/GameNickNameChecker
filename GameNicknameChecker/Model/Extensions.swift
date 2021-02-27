//
//  Extensions.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/30.
//

import Foundation
import UIKit

extension UIImage {
    static var logoutImage = UIImage(systemName: "person.fill.xmark")
    static var myPageImage = UIImage(systemName: "person.crop.circle")

    func resizeImage(size: CGSize) -> UIImage {
        let originalSize = self.size
        let ratio: CGFloat = {
            return originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) :
                                                              1 / (size.height / originalSize.height)
        }()

        return UIImage(cgImage: self.cgImage!, scale: self.scale * ratio, orientation: self.imageOrientation)
    }
}

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
