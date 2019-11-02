//
//  DetailsProtocol.swift
//  LitNet
//
//  Created by Igor Karyi on 01.11.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import RxSwift

protocol DetailsProtocol: class {
    
    func getBookWithId(_ id: Int, completion: @escaping ((Book) -> Void))
    var errorString: Variable<String> { get }
    
}
