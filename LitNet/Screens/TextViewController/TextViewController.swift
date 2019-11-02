//
//  TextViewController.swift
//  LitNet
//
//  Created by Igor Karyi on 02.11.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import UIKit
import RxSwift

class TextViewController: BaseViewController {

    var bookId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        print(bookId ?? 0)
    }
    
}
