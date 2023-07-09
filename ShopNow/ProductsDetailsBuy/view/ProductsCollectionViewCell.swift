//
//  ProductsCollectionViewCell.swift
//  ShopNow
//
//  Created by mayank ranka on 02/07/23.
//

import UIKit
import SDWebImage

class ProductsCollectionViewCell: UICollectionViewCell {
    
    var baseView           : UIView?
    var thumbnailImage     : UIImageView?
    var titleLabel         : UILabel?
    var imageHeight        : CGFloat?
    
    override init(frame : CGRect){
        super.init(frame: frame)
        imageHeight = self.frame.size.height / 1.5
        loadBaseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadBaseView(){
        baseView = UIView()
        baseView!.translatesAutoresizingMaskIntoConstraints = false
        baseView!.backgroundColor = UIColor.gray
        baseView!.layer.cornerRadius = 8.0
        baseView!.layer.borderWidth = 1
        baseView!.layer.borderColor = UIColor.darkGray.cgColor
        self.addSubview(baseView!)
        NSLayoutConstraint.activate([
            baseView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            baseView!.topAnchor.constraint(equalTo: self.topAnchor),
            baseView!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            baseView!.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        titleLabel = UILabel()
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel!.text = "titleLabel"
        titleLabel!.numberOfLines = 1
        titleLabel!.font = UIFont.systemFont(ofSize: 13)
        titleLabel!.textColor = UIColor(hexString: AppConstant.secondaryTextColor)
        titleLabel!.textAlignment = .left
        baseView!.addSubview(titleLabel!)
        NSLayoutConstraint.activate([
            titleLabel!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: 2),
            titleLabel!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor, constant: -2),
            titleLabel!.bottomAnchor.constraint(equalTo: baseView!.bottomAnchor, constant: -2)
        ])
        
        thumbnailImage = UIImageView()
        thumbnailImage!.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage!.image = UIImage(named:"imagesIcon.jpeg")
        thumbnailImage!.layer.cornerRadius = 8.0
        thumbnailImage!.layer.masksToBounds = true
        thumbnailImage!.contentMode = .scaleToFill
        baseView!.addSubview(thumbnailImage!)
        NSLayoutConstraint.activate([
            thumbnailImage!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: 2),
            thumbnailImage!.topAnchor.constraint(equalTo: baseView!.topAnchor, constant: 2),
            thumbnailImage!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor, constant: -2),
            thumbnailImage!.bottomAnchor.constraint(equalTo: titleLabel!.topAnchor, constant: -2)
        ])
    }
    
    func updateCellForProductDetails(products: ProductsModel) {
        titleLabel!.text = products.title
        thumbnailImage!.sd_setImage(with: URL(string: products.thumbnail!))
    }
}
