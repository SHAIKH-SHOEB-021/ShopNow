//
//  SettingTableViewCell.swift
//  ShopNow
//
//  Created by mayank ranka on 02/07/23.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        baseView.backgroundColor = UIColor(hexString: AppConstant.secondaryTextColor)
        baseView.layer.cornerRadius = padding!
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: fontSize!)
        titleLabel.textColor = UIColor(hexString: AppConstant.textLabelColor)
        titleLabel.backgroundColor = UIColor.clear
        
        iconImage.tintColor = UIColor(hexString: AppConstant.textLabelColor)
    }
    
    func updateCellForSettingViewController(settingModel: AppConstant) {
        titleLabel.text = settingModel.title
        iconImage.image = UIImage(systemName: settingModel.icon!)
    }
    
}
