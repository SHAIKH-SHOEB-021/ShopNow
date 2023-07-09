//
//  CategorysCollectionViewCell.swift
//  ShopNow
//
//  Created by mayank ranka on 03/07/23.
//

import UIKit

class CategorysCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var deviceManager         : DeviceManager?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadDeviceManager()
        loadBaseView()
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
        baseView.layer.cornerRadius = padding!*1.5
        baseView.clipsToBounds = true
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = UIColor(hexString: AppConstant.borderColor)?.cgColor
        baseView.backgroundColor =  UIColor(hexString: AppConstant.secondaryTextColor)
        
        titleLabel.textColor = UIColor(hexString: AppConstant.textLabelColor)
        titleLabel.font = UIFont.boldSystemFont(ofSize: fontSize!)
    }
    
    func updateCellForCategory(category: String) {
        titleLabel.text = category
    }

}
