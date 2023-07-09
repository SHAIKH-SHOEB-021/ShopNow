//
//  AppConstant.swift
//  ShopNow
//
//  Created by mayank ranka on 26/06/23.
//

import UIKit

class AppConstant: NSObject {
    
    var id    : Int?
    var title : String?
    var index : Int?
    var icon  : String?
    
    static var backgroundColor    = "#f2f2f2"
    static var navigationColor    = "#0099ff"
    static var statusBarColor     = "#008ae6"
    static var searchBarColor     = "#b3b3b3"
    static var textLabelColor     = "#000000"
    static var secondaryTextColor = "#ffffff"
    static var borderColor        = "#cccccc"
    static var activityIndicator  = "#808080"
    
    static var BASE_URL = "https://dummyjson.com/"
    
    static var navigationTitleColor : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(hexString: "#ffffff") as Any]
    
    static func setCardBackgroud(heightAnchor: CGFloat, stackView: UIStackView) -> UIView {
        let baseView = UIView()
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 10.0
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        baseView.backgroundColor = UIColor(hexString: AppConstant.secondaryTextColor)
        // adding inside the mainStackView that's why i have called the views in a manner it should be visible to the user
        stackView.addArrangedSubview(baseView)
        NSLayoutConstraint.activate([
            baseView.heightAnchor.constraint(equalToConstant: heightAnchor)
        ])
        return baseView
    }
    
    static func getSettingsViewControllerProvider() -> [AppConstant] {
        var models = [AppConstant]()
        
        let model1 = AppConstant()
        model1.id = 1
        model1.title = "View Profile"
        model1.index = 0
        model1.icon = "person.crop.circle"
        models.append(model1)
        
        let model2 = AppConstant()
        model2.id = 2
        model2.title = "View Products In Cart"
        model2.index = 1
        model2.icon = "cart"
        models.append(model2)
        
        let model3 = AppConstant()
        model3.id = 3
        model3.title = "View Order History"
        model3.index = 2
        model3.icon = "bag"
        models.append(model3)
        
        let model4 = AppConstant()
        model4.id = 4
        model4.title = "Logout"
        model4.index = 3
        model4.icon = "power.circle"
        models.append(model4)
        
        return models
    }

}
