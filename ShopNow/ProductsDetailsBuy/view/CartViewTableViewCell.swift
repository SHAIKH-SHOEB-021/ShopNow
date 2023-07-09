//
//  CartViewTableViewCell.swift
//  ShopNow
//
//  Created by mayank ranka on 05/07/23.
//

import UIKit

protocol CartViewTableViewCellDelegate : NSObjectProtocol {
    func removeToCartView(cellIndex: Int)
    func plusProductQuantity(cellIndex: Int)
    func minusProductQuantity(cellIndex: Int)
}

class CartViewTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productStock: UILabel!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var removeToCart: UIImageView!
    @IBOutlet weak var plusQuantity: UIImageView!
    @IBOutlet weak var minusQuantity: UIImageView!
    
    var delegate              : CartViewTableViewCellDelegate?
    var deviceManager         : DeviceManager?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    var cellIndex             : Int?
    
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
        baseView.layer.cornerRadius = padding!
        baseView.clipsToBounds = true
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        baseView.backgroundColor =  UIColor(hexString: AppConstant.secondaryTextColor)
        
        thumbnailImage!.clipsToBounds = true
        thumbnailImage!.layer.cornerRadius = padding!
        
        productTitle.font = UIFont.systemFont(ofSize: fontSize!)
        productTitle.textColor = UIColor(hexString: AppConstant.textLabelColor)
        
        productPrice.font = UIFont.systemFont(ofSize: fontSize!)
        productPrice.textColor = UIColor(hexString: AppConstant.textLabelColor)
        
        productStock.font = UIFont.systemFont(ofSize: fontSize!)
        productStock.textColor = UIColor(hexString: AppConstant.textLabelColor)
        
        productCount.font = UIFont.systemFont(ofSize: fontSize!)
        productCount.textColor = UIColor(hexString: AppConstant.textLabelColor)
        
        removeToCart.isUserInteractionEnabled = true
        removeToCart.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnRemoveToCart)))
        
        plusQuantity.isUserInteractionEnabled = true
        plusQuantity.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnPlusQuantity)))
        
        minusQuantity.isUserInteractionEnabled = true
        minusQuantity.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnMinusQuantity)))
        
    }
    
    func updateCellForAddToCart(addCartModel: AddToCardModel,  cellIndex: Int) {
        self.cellIndex = cellIndex
        thumbnailImage!.sd_setImage(with: URL(string: addCartModel.imageUrl!))
        productTitle.text = addCartModel.productTitle
        productPrice.text = "$ \(addCartModel.productPrice!)"
        productStock.text = "Stock : \(addCartModel.productStock!)"
        productCount.text = "Quantity : \(addCartModel.productQuantity)"
    }
    
    @objc func clickOnRemoveToCart() {
        print("clickOnRemoveToCart")
        delegate!.removeToCartView(cellIndex: cellIndex!)
    }
    
    @objc func clickOnPlusQuantity() {
        print("clickOnPlusQuantity")
        delegate!.plusProductQuantity(cellIndex: cellIndex!)
    }
    
    @objc func clickOnMinusQuantity() {
        print("clickOnMinusQuantity")
        delegate!.minusProductQuantity(cellIndex: cellIndex!)
    }
}
