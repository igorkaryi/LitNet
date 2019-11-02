//
//  DetailsViewModel.swift
//  LitNet
//
//  Created by Igor Karyi on 01.11.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import Moya
import Moya_ObjectMapper
import RxSwift

class DetailsViewModel: DetailsProtocol {
    
    private let service = MoyaProvider<MoyaService>()
    
    var errorString = Variable<String>("")
    
    func getBookWithId(_ id: Int, completion: @escaping ((Book) -> Void)) {
        service.request(.book(id: id)) { [weak self] (result) in
            switch result {
            case .success(let response):                
                guard let data = try? response.mapObject(Book.self)  else { return }
                completion(data)
            case .failure(let error):
                self?.errorString.value = error.errorDescription ?? "unknown error"
            }
        }
    }

}
