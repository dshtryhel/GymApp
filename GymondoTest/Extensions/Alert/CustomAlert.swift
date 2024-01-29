//
//  CustomAlert.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 26.01.2024.
//

import UIKit

final class CustomAlert: NSObject {
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 15
        return alert
    }()
    
    func showAlert(with title: String,
                   message: String,
                   on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 45,
                                 y: -300,
                                 width: targetView.frame.size.width - 80,
                                 height: 200)
        
        let titleLabel = UILabel(frame: CGRect(x: 0,
                                               y: 10,
                                               width: alertView.frame.size.width,
                                               height: 30))
        
        titleLabel.text = title
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                               y: 45,
                                               width: alertView.frame.size.width,
                                               height: 90))
        
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        alertView.addSubview(messageLabel)
        
        let button = UIButton(frame: CGRect(x: 0,
                                            y: alertView.frame.size.height - 50,
                                            width: alertView.frame.size.width,
                                            height: 50))
        button.setTitle("OK", for: .normal)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self,
                         action: #selector(dismissAlert),
                         for: .touchUpInside)
        alertView.addSubview(button)
        
        alertView.center = targetView.center
        
        targetView.addSubview(alertView)
    }
    
    @objc func dismissAlert() {
        alertView.removeFromSuperview()
        backgroundView.removeFromSuperview()
    }

}
