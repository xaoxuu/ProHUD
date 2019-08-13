//
//  EmptyVC.swift
//  Example
//
//  Created by xaoxuu on 2019/8/12.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import SnapKit
import Inspire

class EmptyVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        // Do any additional setup after loading the view.
        
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.text = title
        lb.font = .regular(40)
        view.addSubview(lb)
        lb.snp.makeConstraints { (mk) in
            mk.center.equalToSuperview()
            mk.leading.greaterThanOrEqualToSuperview().offset(16)
            mk.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = .bold(20)
        btn.setTitle("Dismiss", for: .normal)
        btn.addTarget(self, action: #selector(didTappedDismiss(_:)), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (mk) in
            mk.top.equalToSuperview().offset(Inspire.current.layout.safeAreaInsets(for: self).top)
            mk.trailing.equalToSuperview().offset(-16)
            mk.height.equalTo(44)
        }
    }
    
    @objc func didTappedDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension UIViewController {
    func presentEmptyVC(title: String?) {
        let vc = EmptyVC()
        vc.title = title
        present(vc, animated: true, completion: nil)
    }
}
