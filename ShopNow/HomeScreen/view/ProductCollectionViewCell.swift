//
//  ProductCollectionViewCell.swift
//  ShopNow
//
//  Created by mayank ranka on 01/07/23.
//

import UIKit
import SDWebImage

class ProductCollectionViewCell: UICollectionViewCell {
    
    var deviceManager      : DeviceManager?
    var baseStackView      : UIStackView?
    
    var baseView           : UIView?
    var thumbnailImage     : UIImageView?
    var titleLabel         : UILabel?
    var productRatingLabel : UILabel?
    var productPriceLabel  : UILabel?
    var imageHeight        : CGFloat?
    
    var padding            : CGFloat?
    var fontSize           : CGFloat?
    
    override init(frame : CGRect){
        super.init(frame: frame)        
        imageHeight = self.frame.size.height / 1.6
        loadDeviceManager()
        loadBaseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            padding = 8
            fontSize = 14
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhone || deviceManager!.deviceType == deviceManager!.iPhoneX {
            padding = 10
            fontSize = 16
        }else{
            padding = 8
            fontSize = 14
        }
    }
    
    func loadBaseView(){
        baseView = UIView()
        baseView!.translatesAutoresizingMaskIntoConstraints = false
        baseView!.backgroundColor = UIColor(hexString: AppConstant.secondaryTextColor)
        baseView!.layer.cornerRadius = 8.0
        baseView!.layer.borderWidth = 1
        baseView!.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        self.addSubview(baseView!)
        NSLayoutConstraint.activate([
            baseView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            baseView!.topAnchor.constraint(equalTo: self.topAnchor),
            baseView!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            baseView!.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        thumbnailImage = UIImageView()
        thumbnailImage!.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage!.image = UIImage(named:"imagesIcon.jpeg")
        thumbnailImage!.layer.cornerRadius = 8.0
        thumbnailImage!.layer.masksToBounds = true
        thumbnailImage!.contentMode = .scaleToFill
        baseView!.addSubview(thumbnailImage!)
        NSLayoutConstraint.activate([
            thumbnailImage!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: padding!),
            thumbnailImage!.topAnchor.constraint(equalTo: baseView!.topAnchor, constant: padding!),
            thumbnailImage!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor, constant: -padding!),
            thumbnailImage!.heightAnchor.constraint(equalToConstant: imageHeight!)
        ])
        
        baseStackView = UIStackView()
        baseStackView!.translatesAutoresizingMaskIntoConstraints = false
        baseStackView!.axis  = NSLayoutConstraint.Axis.vertical
        baseView!.addSubview(baseStackView!)
        NSLayoutConstraint.activate([
            baseStackView!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: padding!),
            baseStackView!.topAnchor.constraint(equalTo: thumbnailImage!.bottomAnchor, constant: padding!),
            baseStackView!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor, constant: -padding!),
        ])
        
        titleLabel = UILabel()
        titleLabel!.text = "titleLabel"
        titleLabel!.numberOfLines = 2
        titleLabel!.font = UIFont.systemFont(ofSize: fontSize!)
        titleLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        titleLabel!.textAlignment = .left
        baseStackView!.addArrangedSubview(titleLabel!)

        productRatingLabel = UILabel()
        productRatingLabel!.text = "productRatingLabel"
        productRatingLabel!.numberOfLines = 1
        productRatingLabel!.font = UIFont.systemFont(ofSize: fontSize!)
        productRatingLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        productRatingLabel!.textAlignment = .left
        baseStackView!.addArrangedSubview(productRatingLabel!)

        productPriceLabel = UILabel()
        productPriceLabel!.text = "productPriceLabel"
        productPriceLabel!.numberOfLines = 1
        productPriceLabel!.font = UIFont.systemFont(ofSize: fontSize!)
        productPriceLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        productPriceLabel!.textAlignment = .left
        baseStackView!.addArrangedSubview(productPriceLabel!)
    }
    
    func updateCellForHomeViewController(products: ProductsModel) {
        titleLabel!.text = products.title
        thumbnailImage!.sd_setImage(with: URL(string: products.thumbnail!))
        productRatingLabel!.text = "Rating : \(products.rating!)"
        productPriceLabel!.text = "$ \(products.price!)"
    }
}
