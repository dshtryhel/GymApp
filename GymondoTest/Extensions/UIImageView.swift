//
//  UIImageView+URLLoad.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 23.01.2024.
//

import UIKit

extension UIImageView {
    
    func loadFromURL(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
        
    }
    
}


