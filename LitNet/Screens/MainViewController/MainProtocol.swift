//
//  MainProtocol.swift
//  LitNet
//
//  Created by Igor Karyi on 31.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import RxSwift

protocol MainProtocol: class {
    
    func getLibrary(completion: @escaping (([Library]) -> Void))
    var errorString: Variable<String> { get }
    
}
