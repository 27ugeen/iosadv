//
//  Utils.swift
//  Navigation
//
//  Created by GiN Eugene on 25/10/21.
//

import Foundation
import UIKit
import iOSIntPackage

public func putFilterOnImage(_ image: UIImage, _ filterOn: ColorFilter) -> UIImage {
    var filteredImage: UIImage?
    ImageProcessor().processImage(sourceImage: image, filter: filterOn) { processedImage in
        filteredImage = processedImage
    }
    return filteredImage ?? image
}

public func reciveImagesArrFromPhotoStorage(photos: AnyObject) -> [UIImage] {
    var imageArray: [UIImage] = []
    
         PhotosStorage.tableModel.forEach { PhotosSection in
             PhotosSection.photos.forEach { Photo in
                 imageArray.append(Photo.image)
             }
         }
    return imageArray
}

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension String {
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UIViewController {
    func showAlert(message: String) {
        let alertTitle = "alert_error".localized()
        let alertOk = "alert_ok".localized()
        let alertVC = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: alertOk, style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension UITabBar {
    static func setTransparentTabbar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}

extension UIColor {
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}