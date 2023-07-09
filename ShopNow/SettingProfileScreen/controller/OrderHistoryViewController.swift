//
//  OrderHistoryViewController.swift
//  ShopNow
//
//  Created by mayank ranka on 03/07/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class OrderHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var deviceManager         : DeviceManager?
    var navigationBar         : UINavigationBar?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    var cellWidth             : CGFloat?
    var imageHieght           : CGFloat?
    
    var orderHistoryTableView : UITableView?
    
    var activityIndicator     = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var uid                   : String?
    var noRecordFound         : UILabel?
    
    var orderHistoryModel     : [OrderDetails]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: AppConstant.backgroundColor)
        uid = UserDefaults.standard.string(forKey: "userID")
        orderHistoryModel = []
        loadDeviceManager()
        loadStatusBar()
        loadNavigationBar()
        loadOrderHistorryTableView()
        loadfetchUserData()
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        cellWidth = self.view.frame.size.width / 2 - padding!*3
        imageHieght = self.view.frame.size.height / 3
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
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = "Order History"
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
    
    func addToCartIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = UIColor(hexString: AppConstant.activityIndicator)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func noRecordFounds() {
        noRecordFound = UILabel()
        noRecordFound!.translatesAutoresizingMaskIntoConstraints = false
        noRecordFound!.text = "Not Product History"
        noRecordFound!.font = UIFont.boldSystemFont(ofSize: fontSize!)
        noRecordFound!.textColor = UIColor(hexString: AppConstant.searchBarColor)
        noRecordFound!.textAlignment = .center
        noRecordFound!.isUserInteractionEnabled = true
        self.view.addSubview(noRecordFound!)
        NSLayoutConstraint.activate([
            noRecordFound!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noRecordFound!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func loadOrderHistorryTableView() {
        orderHistoryTableView = UITableView()
        orderHistoryTableView!.translatesAutoresizingMaskIntoConstraints = false
        orderHistoryTableView!.backgroundColor = UIColor.clear
        orderHistoryTableView!.register(UINib(nibName: "ProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductsTableViewCell")
        orderHistoryTableView!.delegate = self
        orderHistoryTableView!.dataSource = self
        orderHistoryTableView!.separatorStyle = .none
        orderHistoryTableView!.showsVerticalScrollIndicator = false
        self.view.addSubview(orderHistoryTableView!)
        NSLayoutConstraint.activate([
            orderHistoryTableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding!),
            orderHistoryTableView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: padding!),
            orderHistoryTableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding!),
            orderHistoryTableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -padding!)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ProductsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell", for: indexPath) as! ProductsTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.updateCellForOrderHistory(orderData: orderHistoryModel![indexPath.row])
        return cell
    }
    
    @objc func backButton() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func loadfetchUserData() {
        let db = Firestore.firestore()
        let docRef = db.collection("userDetails").document(uid!).collection("orderPlace")
        docRef.document(uid!).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let productsData = data?["orderData"] as? [[String: Any]] {
                    // Process the productsData array of dictionaries
                    for productData in productsData {
                        // Access the values from each productData dictionary
                        if let productId = productData["productId"] as? String {
                            // Access other properties as needed
                            let imageUrl = productData["imageUrl"] as? String
                            let productTitle = productData["productTitle"] as? String
                            let productPrice = productData["productPrice"] as? String
                            let productStock = productData["productStock"] as? String
                            let deliveryDate = productData["deliveryDate"] as? String
                            let productQuantity = productData["productQuantity"] as? String
                            // Create your model objects or perform any further processing
                           let orderData = OrderDetails(productId: productId, imageUrl: imageUrl, productTitle: productTitle, productPrice: productPrice, productQuantity: productQuantity, deliveryDate: deliveryDate)
                            self.orderHistoryModel!.append(orderData)
                            print(self.orderHistoryModel!)
                            // Add the product to your array or perform other operations
                        }
                    }
                    self.orderHistoryTableView!.reloadData()
                }
            } else {
                print("Document does not exist")
                noRecordFounds()
            }
        }
    }
}
