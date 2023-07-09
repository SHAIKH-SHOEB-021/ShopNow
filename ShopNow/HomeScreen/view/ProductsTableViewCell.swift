//
//  ProductsTableViewCell.swift
//  ShopNow
//
//  Created by mayank ranka on 04/07/23.
//

import UIKit
import SDWebImage

class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productRating: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDelivery: UILabel!
    
    var deviceManager         : DeviceManager?
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadDeviceManager()
        loadBaseView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    func loadBaseView() {
        baseView.clipsToBounds = true
        baseView.layer.cornerRadius = padding!
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = UIColor(hexString: AppConstant.borderColor)?.cgColor
        baseView.backgroundColor = UIColor(hexString: AppConstant.secondaryTextColor)
        
        thumbnailImage.clipsToBounds = true
        thumbnailImage.layer.cornerRadius = padding!
        
        productTitle.font = UIFont.systemFont(ofSize: fontSize!)
        productTitle.textColor = UIColor(hexString: AppConstant.textLabelColor)
        
        productRating.font = UIFont.systemFont(ofSize: fontSize!)
        productRating.textColor = UIColor(hexString: AppConstant.textLabelColor)
        
        productPrice.font = UIFont.boldSystemFont(ofSize: fontSize!)
        productPrice.textColor = UIColor(hexString: AppConstant.textLabelColor)
        
        productDelivery.font = UIFont.systemFont(ofSize: fontSize!)
        productDelivery.textColor = UIColor(hexString: AppConstant.textLabelColor)
    }
    
    func updateCellForCategoryViewController(category: ProductsModel) {
        thumbnailImage!.sd_setImage(with: URL(string: category.thumbnail!))
        productTitle.text = category.title
        productRating.text = "Rating: \(category.rating!)"
        productPrice.text = "$ \(category.price!)"
        productDelivery.text = "Free Delivery"
    }
    
    func updateCellForOrderHistory(orderData: OrderDetails) {
        thumbnailImage!.sd_setImage(with: URL(string: orderData.imageUrl!))
        productTitle.text = orderData.productTitle
        productRating.text = "Quantity: \(orderData.productQuantity!)"
        productPrice.text = "$ \(orderData.productPrice!)"
        productDelivery.text = "Delivered On \(orderData.deliveryDate!)"
    }
    
}
