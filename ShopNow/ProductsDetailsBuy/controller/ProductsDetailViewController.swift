//
//  ProductsDetailViewController.swift
//  ShopNow
//
//  Created by mayank ranka on 02/07/23.
//

import UIKit
import Firebase

class ProductsDetailViewController: UIViewController {
    
    
    var deviceManager         : DeviceManager?
    var navigationBar         : UINavigationBar?
    
    var productsModel         : ProductsModel?
    var productModel          : [ProductsModel]?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    var cellWidth             : CGFloat?
    var imageHieght           : CGFloat?
    var imageWidth            : CGFloat?
    
    var addToCartButton       : UIButton?
    var productDetailsView    : ProductDetailsView?
    
    var cellIndex             : Int?
    var uid                   : String?
    var deliveryDate          : String?
    var activityIndicator     = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var productId             : Int?


    override func viewDidLoad() {
        super.viewDidLoad()
        productId = 0
        self.view.backgroundColor = UIColor(hexString: AppConstant.backgroundColor)
        uid = UserDefaults.standard.string(forKey: "userID")!
        loadDeviceManager()
        loadStatusBar()
        laodNavigationBar()
        loadBaseView()
        updateProductDetailsView(products: productsModel!)
        addCartIndicator()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        cellWidth = self.view.frame.size.width / 2 - padding!*3
        imageHieght = self.view.frame.size.height / 3
        imageWidth = self.view.frame.size.width - padding!*2
    }
    
    func loadStatusBar() {
        if #available(iOS 13.0, *) {
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor(hexString: AppConstant.statusBarColor)
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(statusbarView)
            NSLayoutConstraint.activate([
                statusbarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                statusbarView.topAnchor.constraint(equalTo: self.view.topAnchor),
                statusbarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                statusbarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
            ])
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor(hexString: AppConstant.statusBarColor)
        }
    }
    
    func laodNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = "Product Details"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(backButton))
        navigationBar!.items = [navigationItem]
        navigationBar!.barTintColor = UIColor(hexString: AppConstant.navigationColor)
        navigationBar!.tintColor = UIColor(hexString: AppConstant.secondaryTextColor)
        navigationBar!.titleTextAttributes = AppConstant.navigationTitleColor
        self.view.addSubview(navigationBar!)
        NSLayoutConstraint.activate([
            navigationBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationBar!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func loadBaseView() {
        addToCartButton = UIButton()
        addToCartButton!.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton!.backgroundColor = UIColor(hexString: AppConstant.navigationColor)
        addToCartButton!.layer.borderWidth = 1
        addToCartButton!.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        addToCartButton!.setTitleColor(UIColor(hexString: AppConstant.secondaryTextColor), for: .normal)
        addToCartButton!.layer.cornerRadius = padding!
        addToCartButton!.setTitle("Add To Cart", for: .normal)
        addToCartButton!.titleLabel!.font = UIFont.boldSystemFont(ofSize: fontSize!)
        addToCartButton!.addTarget(self, action: #selector(addToCartPress), for: .touchUpInside)
        self.view.addSubview(addToCartButton!)
        NSLayoutConstraint.activate([
            addToCartButton!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding!),
            addToCartButton!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding!),
            addToCartButton!.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding!)
        ])
        
        productDetailsView = ProductDetailsView(imageHeight: imageHieght!, imageWidth: imageWidth!, productsModel: productModel!, cellIndex: cellIndex!)
        productDetailsView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productDetailsView!)
        NSLayoutConstraint.activate([
            productDetailsView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productDetailsView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor),
            productDetailsView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productDetailsView!.bottomAnchor.constraint(equalTo: addToCartButton!.topAnchor, constant: -padding!)
        ])
    }
    
    func addCartIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = UIColor(hexString: AppConstant.activityIndicator)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func updateProductDetailsView(products: ProductsModel) {
        var price = products.price!
        var discount = products.discountPercentage!
        var discountAmount = price * discount / 100
        var discountPrice = price - discountAmount

        productDetailsView!.productTitle!.text = products.title
        productDetailsView!.productPrice!.text = "Price : $\(products.price!)"
        productDetailsView!.productDiscription!.text = "Discription : \(products.descrip!)"
        productDetailsView!.productRating!.text = "Rating : \(products.rating!)"
        productDetailsView!.productDiscount!.text = "Discount : \(products.discountPercentage!) % Off"
        productDetailsView!.productBrand!.text = "Brand : \(products.brand!)"
        productDetailsView!.productStock!.text = "Available Stock : \(products.stock!)"
        productDetailsView!.finalPrice!.text = "Total : $\(round(discountPrice)) Savings : $\(round(discountAmount))"
        deliveryDate = getCurrentShortDate()
        productDetailsView!.deliveryLabel!.text = "Free delivery \(deliveryDate!)"
    }
    
    
    func getCurrentShortDate() -> String {
        var todaysDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        var DateInFormat = dateFormatter.string(from: todaysDate!)
        return DateInFormat
    }
    
    @objc func addToCartPress() {
        productId! += 1
        activityIndicator.startAnimating()
        let db = Firestore.firestore()
        let addCartData: [String: Any] = ["productId": "\(productsModel!.id!)","imageUrl": self.productsModel!.thumbnail!, "productTitle": self.productsModel!.title!, "productPrice": "\(productsModel!.price!)", "productStock": "\(productsModel!.stock!)", "deliveryDate": self.deliveryDate!]
        db.collection("userDetails").document(uid!).collection("addToCart").document("productId\(productsModel!.id!)").setData(addCartData) { [self] err in
            if let err = err {
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "Something Went Wrong", message: "Add To Cart Error: \(err)", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    self.navigationController!.popViewController(animated: true)
                }])
            } else {
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "Successfully", message: "Add Cart Successfully", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    self.navigationController!.popViewController(animated: true)
                }])
            }
        }
    }
    
    @objc func backButton() {
        self.navigationController!.popViewController(animated: true)
    }
}
