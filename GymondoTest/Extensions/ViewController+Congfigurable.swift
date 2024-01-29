//
//  ViewController+Congfigurable.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 20.01.2024.
//

import UIKit

protocol ViewControllerCongfigurable: AnyObject {
    func setupViews()
    func setupSignals()
}

extension UIViewController: ViewControllerCongfigurable {
    @objc func setupViews() {}
    @objc func setupSignals() {}
}
