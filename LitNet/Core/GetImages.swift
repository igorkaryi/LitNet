//
//  GetImages.swift
//  LitNet
//
//  Created by Igor Karyi on 01.11.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import UIKit

final class GetImages {
    
    static let shared = GetImages()
    
    func getImageWithUrl(_ url: String, completion: @escaping ((UIImage?) -> Void)) {
        let url = URL(string: url)
        var request = URLRequest(url:url!)
        request.setValue("image/png" , forHTTPHeaderField: "Content-Type")
        
        request.setValue(Config.shared.appKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(
            with: request,
            completionHandler: { (data, respones, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                let imageToCache = UIImage(data: data!)
                DispatchQueue.main.async(execute: {
                    completion(imageToCache)
                })
        }).resume()
    }
    
}
