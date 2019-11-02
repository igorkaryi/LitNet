//
//  MainViewModel.swift
//  LitNet
//
//  Created by Igor Karyi on 31.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import Moya
import Moya_ObjectMapper
import RxSwift

class MainViewModel: MainProtocol {
    
    private let service = MoyaProvider<MoyaService>()
    
    var errorString = Variable<String>("")
    
    func getLibrary(completion: @escaping (([Library]) -> Void)) {
        service.request(.library) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let data = try? response.mapArray(Library.self) else { return }
                completion(data)
            case .failure(let error):
                self?.errorString.value = error.errorDescription ?? "unknown error"
            }
        }
    }

}
