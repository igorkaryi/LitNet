//
//  MoyaService.swift
//  LitNet
//
//  Created by Igor Karyi on 31.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import Moya

enum MoyaService {
    case library
    case book(id: Int)
}

extension MoyaService: TargetType {
    
    var baseURL: URL { return URL(string: "http://api.test.lit-era.com/v1")! }
    
    var path: String {
        switch self {
        case .library:
            return "/library/get"
        case .book:
            return "/book/get"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .library:
            return .get
        case .book:
            return .get
        }
    }
    
    var task: Task {
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: parameterEncoding)
        }
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return [
            "Authorization": Config.shared.appKey
        ]
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .library:
            return [
                "app": "android",
                "user_token": "-eCJYBDvXRSPWsnyfhpZWfxsqvUgyBCF",
                "device_id": "55afee2145b9c467",
                "sign": Config.shared.sign,
                "version": "50"
            ]
        case .book(let id):
            return [
                "id": id,
                "app": "android",
                "user_token": "-eCJYBDvXRSPWsnyfhpZWfxsqvUgyBCF",
                "device_id": "55afee2145b9c467",
                "sign": Config.shared.sign,
                "version": "50"
            ]
        }
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

}
