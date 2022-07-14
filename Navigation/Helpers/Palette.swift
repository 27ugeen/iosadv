//
//  Palette.swift
//  Navigation
//
//  Created by GiN Eugene on 1/5/2022.
//

import Foundation
import UIKit

struct Palette {
    static let appTintColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray6)
    
    static let btnWithBorderLableColor = UIColor.createColor(lightMode: .white, darkMode: .black)
    static let btnWithoutBorderLableColor = UIColor.createColor(lightMode: .systemBlue, darkMode: .white)
    static let mainTextColor = UIColor.createColor(lightMode: .black, darkMode: .white)
    static let imgViewBackgrdColor = UIColor.createColor(lightMode: .black, darkMode: .black)
    
    static let feedBackgrdColor = UIColor.createColor(lightMode: .systemOrange, darkMode: .orange)
    static let postBackgrdColor = UIColor.createColor(lightMode: .systemCyan, darkMode: .blue)
    static let infoBackgrdColor = UIColor.createColor(lightMode: .systemPurple, darkMode: .purple)
}
