//
//  DetailsViewController.swift
//  LitNet
//
//  Created by Igor Karyi on 31.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import UIKit
import RxSwift

class DetailsViewController: BaseViewController {
    
    @IBOutlet fileprivate weak var bgCoverImage: UIImageView!
    @IBOutlet fileprivate weak var coverView: UIView!
    @IBOutlet fileprivate weak var coverImage: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var authorLabel: UILabel!
    @IBOutlet fileprivate weak var annotationTextView: UITextView!
    @IBOutlet fileprivate weak var pagesLabel: UILabel!
    @IBOutlet fileprivate weak var priceTitleLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    private var viewModel: DetailsProtocol?
    
    private var context = CIContext(options: nil)
    
    var bookId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        viewModel = DetailsViewModel()
        
        getBookWithId(bookId ?? 0)
    }
    
    @IBAction func toReadAction(_ sender: UIButton) {
        guard let vc = R.storyboard.main.textViewController() else { return }
        vc.bookId = self.bookId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DetailsViewController {
    
    func getBookWithId(_ id: Int) {
        showHud()
        viewModel?.getBookWithId(id, completion: { [weak self] (book) in
            self?.setBook(book)
        })

        viewModel?.errorString
            .asObservable()
            .subscribe(onNext: { [weak self] errorStr in
                self?.hideHud()
                if (errorStr != "") {
                    print("error")
                }
        }).disposed(by: disposeBag)
    }
    
    private func setBook(_ book: Book) {
        showHud()
        GetImages.shared.getImageWithUrl(book.cover ?? "") { [weak self] (image) in
            self?.bgCoverImage.image = image
            self?.coverImage.image = image
            self?.addShadowOnCoverImage()
            self?.addBlurEffectOnBgImage()
            self?.hideHud()
        }
        title = book.title
        
        titleLabel.text = book.title
        authorLabel.text = book.authorName
        
        setPrice(
            price: book.price ?? 0,
            currency: book.currencyCode ?? ""
        )
        pagesLabel.text = "\(book.pages ?? 0) \(NSLocalizedString("стр.", comment: ""))"

        annotationTextView.attributedText = book.annotation?.htmlToAttributedString
    }
    
    private func setPrice(price: Int, currency: String) {
        priceTitleLabel.text = NSLocalizedString("цена:", comment: "")
        priceTitleLabel.isHidden = price == 0
        
        priceLabel.text = price > 0
            ? "\(price) \(currency)"
            : NSLocalizedString("Бесплатно", comment: "")
    }
    
    private func addShadowOnCoverImage() {
        coverView.layer.shadowColor = UIColor.black.cgColor
        coverView.layer.shadowOpacity = 1
        coverView.layer.shadowOffset = .zero
        coverView.layer.shadowRadius = 10
    }

    private func addBlurEffectOnBgImage() {
        guard let bgImage = bgCoverImage.image else { return }
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: bgImage)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        bgCoverImage.image = processedImage
    }
    
}
