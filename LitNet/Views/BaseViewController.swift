//
//  BaseViewController.swift
//  LitNet
//
//  Created by Igor Karyi on 31.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    func showHud() {
        hud.show(in: self.view)
    }
    
    func hideHud() {
        hud.dismiss()
    }

}
