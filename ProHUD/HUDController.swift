//
//  HUDController.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public class HUDController: UIViewController {

    public var identifier = String(Date().timeIntervalSince1970)
    
    internal var willLayout: DispatchWorkItem?
    
    /// 超时（自动消失）时间
    internal var timeout: TimeInterval?
    
    internal var timeoutBlock: DispatchWorkItem?
    
    /// 消失回调
    internal var disappearCallback: (() -> Void)?
    internal var buttonEvents = [UIButton:() -> Void]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print(self, "init")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(self, "deinit")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}

internal extension HUDController {
    
//    func animateOut(completion: ((Bool) -> Void)? = nil) {
//        UIView.animateForAlertBuildOut(animations: {
//            self.view.alpha = 0
//        }) { (done) in
//            completion?(done)
//        }
//    }
    
    func addTouchUpAction(for button: UIButton, action: @escaping () -> Void) {
        button.addTarget(self, action: #selector(didTappedButton(_:)), for: .touchUpInside)
        buttonEvents[button] = action
    }

    @objc func didTappedButton(_ sender: UIButton) {
        if let ac = buttonEvents[sender] {
            ac()
        }
    }
    
}
