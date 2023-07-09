//
//  CategoryViewController.swift
//  ShopNow
//
//  Created by mayank ranka on 04/07/23.
//

import UIKit

class CategoryViewController: UIViewController, ProductsParserDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var productsParser        : ProductsParser?
    var productsModel         : [ProductsModel]?
    
    var deviceManager         : DeviceManager?
    
    var productDetailsVC      : ProductsDetailViewController?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    var cellWidth             : CGFloat?
    
    var imageHieght           : CGFloat?
    var imageWidth            : CGFloat?
    
    var navigationBar         : UINavigationBar?
    
    var productTableView      : UITableView?
    
    var valueStackView        : UIStackView?
    var lowerPriceLabel       : UILabel?
    var heightPriceLabel      : UILabel?
    var separatorView         : UIView?
    
    var categoryString        : String = ""
    
    var cellIndex             : Int?
    
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: AppConstant.backgroundColor)
        getProductCategory(category: categoryString)
        loadDeviceManager()
        loadStatusBar()
        laodNavigationBar()
        loadValueStackView()
        categoryIndicator()
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
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
        imageWidth = self.view.frame.size.width - padding!*2
        //posY = navigationHeight + UIApplication.shared.statusBarFrame.height + padding
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
        navigationItem.title = categoryString
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
    
    func categoryIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = UIColor(hexString: AppConstant.activityIndicator)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func loadValueStackView() {
        valueStackView = UIStackView()
        valueStackView!.translatesAutoresizingMaskIntoConstraints = false
        valueStackView!.axis = NSLayoutConstraint.Axis.horizontal
        valueStackView!.backgroundColor = UIColor(hexString: AppConstant.secondaryTextColor)
        valueStackView!.distribution = .fillProportionally
        valueStackView!.clipsToBounds = true
        valueStackView!.layer.cornerRadius = padding!
        valueStackView!.layer.borderWidth = 1
        valueStackView!.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        self.view.addSubview(valueStackView!)
        NSLayoutConstraint.activate([
            valueStackView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding!*2),
            valueStackView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: padding!),
            valueStackView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding!*2),
            valueStackView!.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        lowerPriceLabel = UILabel()
        lowerPriceLabel!.text = "Lowest Price"
        lowerPriceLabel!.font = UIFont.boldSystemFont(ofSize: fontSize!)
        lowerPriceLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        lowerPriceLabel!.textAlignment = .center
        lowerPriceLabel!.isUserInteractionEnabled = true
        lowerPriceLabel!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lowerValueSorting)))
        valueStackView!.addArrangedSubview(lowerPriceLabel!)
        
        separatorView = UIView()
        separatorView!.backgroundColor = UIColor(hexString: AppConstant.searchBarColor)
        separatorView!.translatesAutoresizingMaskIntoConstraints = false
        valueStackView!.addArrangedSubview(separatorView!)
        NSLayoutConstraint.activate([
            separatorView!.widthAnchor.constraint(equalToConstant: 1),
            
        ])
        
        heightPriceLabel = UILabel()
        heightPriceLabel!.text = "Highest Price"
        heightPriceLabel!.font = UIFont.boldSystemFont(ofSize: fontSize!)
        heightPriceLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        heightPriceLabel!.textAlignment = .center
        heightPriceLabel!.isUserInteractionEnabled = true
        heightPriceLabel!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(highValueSorting)))
        valueStackView!.addArrangedSubview(heightPriceLabel!)
    }
    
    func loadProductTableView() {
        productTableView = UITableView()
        productTableView!.translatesAutoresizingMaskIntoConstraints = false
        productTableView!.backgroundColor = UIColor.clear
        productTableView!.register(UINib(nibName: "ProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductsTableViewCell")
        productTableView!.delegate = self
        productTableView!.dataSource = self
        productTableView!.separatorStyle = .none
        productTableView!.showsVerticalScrollIndicator = false
        self.view.addSubview(productTableView!)
        NSLayoutConstraint.activate([
            productTableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding!),
            productTableView!.topAnchor.constraint(equalTo: valueStackView!.bottomAnchor, constant: padding!),
            productTableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding!),
            productTableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -padding!)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ProductsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell", for: indexPath) as! ProductsTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.updateCellForCategoryViewController(category: productsModel![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIndex = indexPath.row
        productDetailsVC = ProductsDetailViewController()
        productDetailsVC!.productsModel = productsModel![indexPath.row]
        productDetailsVC!.productModel = productsModel
        productDetailsVC!.cellIndex = cellIndex
        self.navigationController!.pushViewController(productDetailsVC!, animated: true)
    }
    
    
    @objc func lowerValueSorting() {
        self.productsModel!.sort { $0.price! < $1.price! }
        productTableView!.reloadData()
    }
    
    @objc func highValueSorting() {
        self.productsModel!.sort { $0.price! > $1.price! }
        productTableView!.reloadData()
    }
    
    @objc func backButton() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func getProductCategory(category: String) {
        productsParser = ProductsParser()
        productsParser!.delegate = self
        productsParser!.getProductsDetails(category: category)
    }
    
    func didReceivedProducts(products: [ProductsModel]) {
        productsModel = products
        loadProductTableView()
        activityIndicator.stopAnimating()
    }
    
    func didReceivedError() {
        print("Products Details vError")
    }

}
