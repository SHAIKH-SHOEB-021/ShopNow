//
//  ProductDetailsView.swift
//  ShopNow
//
//  Created by mayank ranka on 02/07/23.
//

import UIKit

class ProductDetailsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var scrollView            : UIScrollView?
    var baseView              : UIView?
    
    var productStackView      : UIStackView?
    var productImage          : UIImageView?
    var productTitle          : UILabel?
    var productDiscription    : UILabel?
    var productStock          : UILabel?
    var productDiscount       : UILabel?
    var productRating         : UILabel?
    
    var priceStackView        : UIStackView?
    var productPrice          : UILabel?
    var productBrand          : UILabel?
    
    var finalStackView        : UIStackView?
    var finalPrice            : UILabel?
    var deliveryLabel         : UILabel?
    
    var productCollectView    : UICollectionView?
    
    var imageCollectionView   : UICollectionView?
    
    var productsModel         : [ProductsModel]?
    
    var deviceManager         : DeviceManager?
    
    var productDetailsVC      :  ProductsDetailViewController?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    var imageHeight           : CGFloat?
    var imageWidth            : CGFloat?
    
    var cellIndex             : Int?
    
    init(imageHeight: CGFloat, imageWidth: CGFloat, productsModel: [ProductsModel], cellIndex: Int) {
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        self.productsModel = productsModel
        self.cellIndex = cellIndex
        super.init(frame: .zero)
        loadDeviceManager()
        loadBaseView()
        loadFinalPrice()
        loadProductsCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: New DeviceManager Function
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
    
    
    func loadBaseView() {
        baseView = UIView()
        baseView!.translatesAutoresizingMaskIntoConstraints = false
        baseView!.backgroundColor = UIColor.clear
        self.addSubview(baseView!)
        NSLayoutConstraint.activate([
            baseView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            baseView!.topAnchor.constraint(equalTo: self.topAnchor),
            baseView!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            baseView!.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: imageWidth!, height: imageHeight!)
        flowLayout.scrollDirection = .horizontal
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        imageCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView!.register(UINib(nibName: "ImageCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCarouselCollectionViewCell")
        imageCollectionView!.delegate = self
        imageCollectionView!.dataSource = self
        imageCollectionView!.showsHorizontalScrollIndicator = false
        imageCollectionView!.backgroundColor = UIColor.clear
        baseView!.addSubview(imageCollectionView!)
        NSLayoutConstraint.activate([
            imageCollectionView!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: padding!),
            imageCollectionView!.topAnchor.constraint(equalTo: baseView!.topAnchor, constant: padding!),
            imageCollectionView!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor, constant: -padding!),
            imageCollectionView!.heightAnchor.constraint(equalToConstant: imageHeight!)
        ])
        
        productStackView = UIStackView()
        productStackView!.translatesAutoresizingMaskIntoConstraints = false
        productStackView!.axis  = NSLayoutConstraint.Axis.vertical
        productStackView!.layer.cornerRadius = padding!
        baseView!.addSubview(productStackView!)
        NSLayoutConstraint.activate([
            productStackView!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: padding!),
            productStackView!.topAnchor.constraint(equalTo: imageCollectionView!.bottomAnchor, constant: padding!),
            productStackView!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor, constant: -padding!)
        ])
        
        priceStackView = UIStackView()
        priceStackView!.axis  = NSLayoutConstraint.Axis.horizontal
        priceStackView!.distribution  = UIStackView.Distribution.fillEqually
        productStackView!.addArrangedSubview(priceStackView!)
        
        productTitle = UILabel()
        productTitle!.text = "Non-Alcoholic Concentrated Perfume Oil"
        productTitle!.font = UIFont.boldSystemFont(ofSize: fontSize!)
        productTitle!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        productTitle!.textAlignment = .left
        priceStackView!.addArrangedSubview(productTitle!)
        
        productRating = UILabel()
        productRating!.text = "4.21"
        productRating!.font = UIFont.systemFont(ofSize: fontSize!)
        productRating!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        productRating!.textAlignment = .left
        priceStackView!.addArrangedSubview(productRating!)
        
        productPrice = UILabel()
        productPrice!.text = "120"
        productPrice!.font = UIFont.systemFont(ofSize: fontSize!)
        productPrice!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        productPrice!.textAlignment = .left
        productStackView!.addArrangedSubview(productPrice!)
        
        productDiscount = UILabel()
        productDiscount!.text = "15.6"
        productDiscount!.font = UIFont.systemFont(ofSize: fontSize!)
        productDiscount!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        productDiscount!.textAlignment = .left
        productStackView!.addArrangedSubview(productDiscount!)
        
        productBrand = UILabel()
        productBrand!.text = "Al Munakh"
        productBrand!.font = UIFont.systemFont(ofSize: fontSize!)
        productBrand!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        productBrand!.textAlignment = .left
        productStackView!.addArrangedSubview(productBrand!)
        
        productStock = UILabel()
        productStock!.text = "114"
        productStock!.font = UIFont.systemFont(ofSize: fontSize!)
        productStock!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        productStock!.textAlignment = .left
        productStackView!.addArrangedSubview(productStock!)
        
        productDiscription = UILabel()
        productDiscription!.text = "Original Al Munakh® by Mahal Al Musk | Our Impression of Climate | 6ml Non-Alcoholic Concentrated Perfume Oil"
        productDiscription!.numberOfLines = 0
        productDiscription!.font = UIFont.systemFont(ofSize: fontSize!)
        productDiscription!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        productDiscription!.textAlignment = .left
        productStackView!.addArrangedSubview(productDiscription!)
    }
    
    func loadFinalPrice() {
        finalStackView = UIStackView()
        finalStackView!.translatesAutoresizingMaskIntoConstraints = false
        finalStackView!.axis  = NSLayoutConstraint.Axis.vertical
        baseView!.addSubview(finalStackView!)
        NSLayoutConstraint.activate([
            finalStackView!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: padding!),
            finalStackView!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor, constant: -padding!),
            finalStackView!.bottomAnchor.constraint(equalTo: baseView!.bottomAnchor)
        ])
        
        finalPrice = UILabel()
        finalPrice!.text = "Total : $543"
        finalPrice!.font = UIFont.systemFont(ofSize: fontSize!)
        finalPrice!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        finalPrice!.textAlignment = .left
        finalStackView!.addArrangedSubview(finalPrice!)
        
        deliveryLabel = UILabel()
        deliveryLabel!.text = "Free delivery Sunday, 9 July"
        deliveryLabel!.font = UIFont.systemFont(ofSize: fontSize!)
        deliveryLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        deliveryLabel!.textAlignment = .left
        finalStackView!.addArrangedSubview(deliveryLabel!)
    }
    
    func loadProductsCollectionView() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.itemSize = CGSize(width: imageHeight!/2, height: imageHeight!/2.5)
        flowLayout.scrollDirection = .horizontal
        productCollectView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        productCollectView!.translatesAutoresizingMaskIntoConstraints = false
        productCollectView!.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        productCollectView!.delegate = self
        productCollectView!.dataSource = self
        productCollectView!.showsHorizontalScrollIndicator = false
        productCollectView!.backgroundColor = UIColor.clear
        baseView!.addSubview(productCollectView!)
        NSLayoutConstraint.activate([
            productCollectView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding!),
            productCollectView!.topAnchor.constraint(equalTo: productStackView!.bottomAnchor, constant: padding!),
            productCollectView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding!),
            productCollectView!.bottomAnchor.constraint(equalTo: finalStackView!.topAnchor, constant: -padding!)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView {
            return productsModel![cellIndex!].images!.count
        }else{
            return productsModel!.count / 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView {
            let cell : ImageCarouselCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCarouselCollectionViewCell", for: indexPath) as! ImageCarouselCollectionViewCell
            cell.updateCellForProductThumbnail(thumbnailImagemages: productsModel![cellIndex!].images![indexPath.row], imageCount: productsModel![cellIndex!].images!.count)
            cell.backgroundColor = UIColor.gray
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
            if indexPath.row % 2 != 0 {
                cell.updateCellForProductDetails(products: productsModel![indexPath.row])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellIndex = indexPath.row
        productDetailsVC = ProductsDetailViewController()
        productDetailsVC!.productsModel = productsModel![indexPath.row]
        productDetailsVC!.productModel = productsModel
        productDetailsVC!.cellIndex = cellIndex
//        self.navigationController!.pushViewController(productDetailsVC!, animated: true)
    }

}
