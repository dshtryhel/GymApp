//
//  MBProgress+Rx.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 23.01.2024.
//

import MBProgressHUD
import RxSwift
import RxCocoa

let progressHud: MBProgressHUD = {
    $0.mode = MBProgressHUDMode.indeterminate
    $0.animationType = .zoomIn
    $0.minShowTime = 1
    $0.label.text = ""
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    return $0
}(MBProgressHUD())

extension Reactive where Base: MBProgressHUD {
    public var animation: Binder<Bool> {
        return Binder(self.base) { hud, show in
            guard let view = UIApplication.shared.windows.first?.rootViewController?.view else { return }
            if show {
                if hud.superview != view {
                    view.addSubview(hud)
                }
                
                hud.show(animated: true)
            } else {
                hud.hide(animated: true)
                hud.removeFromSuperview()
            }
        }
    }
}
