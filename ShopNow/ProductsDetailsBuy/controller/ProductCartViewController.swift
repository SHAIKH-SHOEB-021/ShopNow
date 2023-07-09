//
//  ProductCartViewController.swift
//  ShopNow
//
//  Created by mayank ranka on 03/07/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProductCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartViewTableViewCellDelegate {
    
    
    var deviceManager         : DeviceManager?
    var navigationBar         : UINavigationBar?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    var bottomHight           : CGFloat?
    
    var addCartTableView      : UITableView?
    var buyButton             : UIButton?
    
    var activityIndicator     = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var uid                   : String?
    var noRecordFound         : UILabel?
    
    var addCartModel          : [AddToCardModel]?
    
    var bottomView            : UIView?
    var bottomStackView       : UIStackView?
    
    var cashOnDelivery        : UILabel?
    var totalPriceLabel       : UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: AppConstant.backgroundColor)
        uid = UserDefaults.standard.string(forKey: "userID")
        addToCartIndicator()
        activityIndicator.startAnimating()
        loadfetchUserData()
        addCartModel = []
        loadDeviceManager()
        loadStatusBar()
        loadNavigationBar()
        loadBottomView()
        loadBaseView()
        loadTotalPrice()
        loadAddCartTableView()
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
        bottomHight = self.view.frame.size.height / 7
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
        navigationItem.title = "Cart View"
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
        noRecordFound!.text = "Not Add To Cart Product"
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
    
    func loadBottomView() {
        bottomView = UIView()
        bottomView!.translatesAutoresizingMaskIntoConstraints = false
        bottomView!.backgroundColor = UIColor(hexString: AppConstant.secondaryTextColor)
        bottomView!.layer.cornerRadius = padding!*2
        bottomView!.layer.borderWidth = 1
        bottomView!.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        bottomView!.isHidden = true
        self.view.addSubview(bottomView!)
        NSLayoutConstraint.activate([
            bottomView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding!),
            //            bottomView!.bottomAnchor.constraint(equalTo: buyButton!.topAnchor, constant: -padding!),
            bottomView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding!),
            bottomView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -padding!),
            bottomView!.heightAnchor.constraint(equalToConstant: bottomHight!*1.2)
        ])
        
        bottomStackView = UIStackView()
        bottomStackView!.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView!.axis = NSLayoutConstraint.Axis.vertical
        bottomStackView!.distribution = .fillEqually
        bottomStackView!.isHidden = true
        self.view.addSubview(bottomStackView!)
        NSLayoutConstraint.activate([
            bottomStackView!.leadingAnchor.constraint(equalTo: bottomView!.leadingAnchor, constant: padding!*2),
            bottomStackView!.topAnchor.constraint(equalTo: bottomView!.topAnchor, constant: padding!),
            bottomStackView!.trailingAnchor.constraint(equalTo: bottomView!.trailingAnchor, constant: -padding!*2),
            bottomStackView!.heightAnchor.constraint(equalToConstant: bottomHight!*0.5)
        ])
        
        cashOnDelivery = UILabel()
        cashOnDelivery!.text = "Delivery Type : Cash On Delivery"
        cashOnDelivery!.font = UIFont.systemFont(ofSize: fontSize!)
        cashOnDelivery!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        cashOnDelivery!.textAlignment = .left
        bottomStackView!.addArrangedSubview(cashOnDelivery!)
        
        totalPriceLabel = UILabel()
        totalPriceLabel!.text = "Total Price : $543"
        totalPriceLabel!.font = UIFont.systemFont(ofSize: fontSize!)
        totalPriceLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        totalPriceLabel!.textAlignment = .left
        bottomStackView!.addArrangedSubview(totalPriceLabel!)
    }
    
    func loadBaseView() {
        buyButton = UIButton()
        buyButton!.translatesAutoresizingMaskIntoConstraints = false
        buyButton!.backgroundColor = UIColor(hexString: AppConstant.navigationColor)
        buyButton!.layer.borderWidth = 1
        buyButton!.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        buyButton!.setTitleColor(UIColor(hexString: AppConstant.secondaryTextColor), for: .normal)
        buyButton!.layer.cornerRadius = padding!
        buyButton!.setTitle("Buy Now", for: .normal)
        buyButton!.titleLabel!.font = UIFont.boldSystemFont(ofSize: fontSize!)
        buyButton!.addTarget(self, action: #selector(buyNowClick), for: .touchUpInside)
        buyButton!.isHidden = true
        bottomView!.addSubview(buyButton!)
        NSLayoutConstraint.activate([
            buyButton!.leadingAnchor.constraint(equalTo: bottomView!.leadingAnchor),
            buyButton!.trailingAnchor.constraint(equalTo: bottomView!.trailingAnchor),
            buyButton!.heightAnchor.constraint(equalToConstant: 50),
            buyButton!.bottomAnchor.constraint(equalTo: bottomView!.bottomAnchor)
        ])
    }
    
    func loadAddCartTableView() {
        addCartTableView = UITableView()
        addCartTableView!.translatesAutoresizingMaskIntoConstraints = false
        addCartTableView!.register(UINib(nibName: "CartViewTableViewCell", bundle: nil), forCellReuseIdentifier: "CartViewTableViewCell")
        addCartTableView!.delegate = self
        addCartTableView!.dataSource = self
        addCartTableView!.backgroundColor = UIColor.clear
        addCartTableView!.showsVerticalScrollIndicator = false
        addCartTableView!.separatorStyle = .none
        self.view.addSubview(addCartTableView!)
        NSLayoutConstraint.activate([
            addCartTableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding!),
            addCartTableView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: padding!),
            addCartTableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding!),
            addCartTableView!.bottomAnchor.constraint(equalTo: bottomView!.topAnchor, constant: -padding!)
        ])
    }
    
    @objc func backButton() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addCartModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CartViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CartViewTableViewCell", for: indexPath) as! CartViewTableViewCell
        cell.updateCellForAddToCart(addCartModel: addCartModel![indexPath.row], cellIndex: indexPath.row)
        cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func loadfetchUserData() {
        let db = Firestore.firestore()
        let docRef = db.collection("userDetails").document(uid!).collection("addToCart")
        
        docRef.getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                // Parse the documents and populate the model objects
                for document in documents {
                    let productId    = document.data()["productId"] as? String ?? ""
                    let imageUrl     = document.data()["imageUrl"] as? String ?? ""
                    let productTitle = document.data()["productTitle"] as? String ?? ""
                    let productPrice = document.data()["productPrice"] as? String ?? ""
                    let productStock = document.data()["productStock"] as? String ?? ""
                    let deliveryDate = document.data()["deliveryDate"] as? String ?? ""
                    
                    let product = AddToCardModel(productId: productId, imageUrl: imageUrl, productTitle: productTitle, productPrice: productPrice, productStock: productStock, deliveryDate: deliveryDate)
                    self.addCartModel!.append(product)
                }
                // Perform any further operations with the populated array of products
                print(self.addCartModel!)
                addCartTableView!.reloadData()
                if addCartModel!.count == 0 {
                    noRecordFounds()
                    buyButton!.isHidden = true
                    bottomStackView!.isHidden = true
                    bottomView!.isHidden = true
                }else{
                    buyButton!.isHidden = false
                    bottomStackView!.isHidden = false
                    bottomView!.isHidden = false
                }
            }
        }
        activityIndicator.stopAnimating()
    }
    
    @objc func buyNowClick() {
        activityIndicator.startAnimating()
        let db = Firestore.firestore()
        let productsData: [[String: Any]] = addCartModel!.map { product in
            return ["productId": product.productId, "imageUrl": product.imageUrl, "productTitle": product.productTitle, "productPrice": product.productPrice, "productQuantity":"\(product.productQuantity)", "productStock": product.productStock, "deliveryDate": product.deliveryDate]
        }
        db.collection("userDetails").document(uid!).collection("orderPlace").document(uid!).setData(["orderData": productsData]) { [self] err in
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
        addToCartAllDelete()
    }
    
    func addToCartAllDelete() {
        let db = Firestore.firestore()
        let docRef = db.collection("userDetails").document(uid!).collection("addToCart")
        docRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            // Loop through each document in the collection
            for document in snapshot!.documents {
                // Delete each document
                document.reference.delete()
            }
        }
    }
    
    func addToCartDelete(cellIndex: Int) {
        let db = Firestore.firestore()
        let documentRef = db.collection("userDetails").document(uid!).collection("addToCart").document("productId\(addCartModel![cellIndex].productId!)")
        documentRef.delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully deleted!")
            }
        }
    }
    
    func removeToCartView(cellIndex: Int) {
        print("Remove")
        addToCartDelete(cellIndex: cellIndex)
        addCartModel = []
        loadfetchUserData()
        addCartTableView!.reloadData()
        loadTotalPrice()
    }
    
    func plusProductQuantity(cellIndex: Int) {
        addCartModel![cellIndex].productQuantity += 1
        loadTotalPrice()
        addCartTableView!.reloadData()
    }
    
    func minusProductQuantity(cellIndex: Int) {
        addCartModel![cellIndex].productQuantity -= 1
        loadTotalPrice()
        addCartTableView!.reloadData()
    }
    
    func loadTotalPrice() {
        var totalPrice: Double = 0.0
        for product in addCartModel! {
            var productTotal = Double(product.productPrice)! * Double(product.productQuantity)
            totalPrice += productTotal
            totalPriceLabel!.text = "Total Price : $\(totalPrice)"
        }
    }
    
}
