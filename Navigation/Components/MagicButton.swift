//
//  MagicButton.swift
//  Navigation
//
//  Created by GiN Eugene on 20/11/21.
//

import Foundation
import UIKit

final class MagicButton: UIButton {
    //MARK: - props
    
    private let onTap: () -> Void
    
    //MARK: - init
    
    init(title: String, titleColor: UIColor, onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    //MARK: - methods
    
    @objc private func buttonTapped() {
        self.onTap()
    }
}
