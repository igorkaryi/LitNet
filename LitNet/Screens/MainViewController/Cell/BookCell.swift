//
//  BookCell.swift
//  LitNet
//
//  Created by Igor Karyi on 31.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var bgView: UIView!
    @IBOutlet fileprivate weak var coverImage: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var authorLabel: UILabel!
    @IBOutlet fileprivate weak var genreLabel: UILabel!
    @IBOutlet fileprivate weak var priceTitleLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    
    func setModel(_ model: Library) {
        GetImages.shared.getImageWithUrl(model.book?.cover ?? "") { [weak self] (image) in
            self?.coverImage.image = image
        }
        titleLabel.text = model.book?.title
        authorLabel.text = model.book?.authorName
        
        var genres = [String]()
        for item in model.book?.genres ?? [] {
            genres.append(item.name ?? "")
        }
        genreLabel.text = genres.joined(separator: ", ")
        
        setPrice(
            price: model.book?.price ?? 0,
            currency: model.book?.currencyCode ?? ""
        )
    }
    
    private func setPrice(price: Int, currency: String) {
        priceTitleLabel.text = NSLocalizedString("цена:", comment: "")
        priceTitleLabel.isHidden = price == 0
        
        priceLabel.text = price > 0
            ? "\(price) \(currency)"
            : NSLocalizedString("Бесплатно", comment: "")
    }

}
