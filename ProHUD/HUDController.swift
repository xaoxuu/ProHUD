//
//  HUDController.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public class HUDController: UIViewController {
    
    internal var willAppearCallback: (() -> Void)?
    internal var didAppearCallback: (() -> Void)?
    internal var willDisappearCallback: (() -> Void)?
    internal var didDisappearCallback: (() -> Void)?
    
    /// 按钮事件
    internal var buttonEvents = [UIButton:() -> Void]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        debug(self, "init")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debug("👌", self, "deinit")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppearCallback?()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppearCallback?()
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappearCallback?()
    }
    
    public func viewWillAppear(_ callback: (() -> Void)?) {
        willAppearCallback = callback
    }
    public func viewDidAppear(_ callback: (() -> Void)?) {
        didAppearCallback = callback
    }
    
    public func viewWillDisappear(_ callback: (() -> Void)?) {
        willDisappearCallback = callback
    }
    public func viewDidDisappear(_ callback: (() -> Void)?) {
        didDisappearCallback = callback
    }
    
}

internal extension HUDController {
    
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
