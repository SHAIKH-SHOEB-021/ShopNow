//
//  HomeViewController.swift
//  ShopNow
//
//  Created by mayank ranka on 29/06/23.
//

import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ProductsParserDelegate, CategoriesParserDelegate {
    
    var deviceManager            : DeviceManager?
    var navigationBar            : UINavigationBar?
    var productSearchBar         : UISearchBar?
    
    var productsParser           : ProductsParser?
    var productsModel            : [ProductsModel]?
    var productsSearch           : [ProductsModel]?
    
    var categoryParser           : CategoriesParser?
    var categoryModel            : [String]?
    
    var padding                  : CGFloat?
    var fontSize                 : CGFloat?
    var cellWidth                : CGFloat?
    
    var productDetailsVC         : ProductsDetailViewController?
    var settingsVC               : SettingViewController?
    var productCartVC            : ProductCartViewController?
    var categoryVC               : CategoryViewController?
    
    var productsCollectionView   : UICollectionView?
    var categorysCollectionView  : UICollectionView?
    
    var isSearch                 : Bool?
    var cellIndex                : Int?
    
    var activityIndicator        = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: AppConstant.backgroundColor)
        productsSearch = []
        isSearch = false
        getCategoryData()
        loadDeviceManager()
        loadStatusBar()
        laodNavigationBar()
        loadBaseView()
        loadHomeIndicator()
        activityIndicator.startAnimating()
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
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: self, action: #selector(ClickOnSetting))
        let addToCartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .done, target: self, action: #selector(ClickOnCartView))
        navigationItem.rightBarButtonItems = [settingButton, addToCartButton]
        navigationItem.title = "Shop Now"
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
    
    func loadHomeIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = UIColor(hexString: AppConstant.activityIndicator)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func loadBaseView() {
        productSearchBar = UISearchBar()
        productSearchBar!.translatesAutoresizingMaskIntoConstraints = false
        productSearchBar!.delegate = self
        productSearchBar!.placeholder = "Search"
        productSearchBar!.searchTextField.backgroundColor = UIColor(hexString: AppConstant.secondaryTextColor)
        productSearchBar!.barTintColor = UIColor(hexString: AppConstant.searchBarColor)
        productSearchBar!.showsCancelButton = false
        self.view.addSubview(productSearchBar!)
        NSLayoutConstraint.activate([
            productSearchBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productSearchBar!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor),
            productSearchBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func loadCategorysCollectionView() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: 140, height: 45)
        flowLayout.scrollDirection = .horizontal
        categorysCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        categorysCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        categorysCollectionView!.register(UINib(nibName: "CategorysCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategorysCollectionViewCell")
        categorysCollectionView!.delegate = self
        categorysCollectionView!.dataSource = self
        categorysCollectionView!.showsHorizontalScrollIndicator = false
        categorysCollectionView!.backgroundColor = UIColor.clear //UIColor(hexString: AppConstant.secondaryTextColor)
        self.view.addSubview(categorysCollectionView!)
        NSLayoutConstraint.activate([
            categorysCollectionView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding!),
            categorysCollectionView!.topAnchor.constraint(equalTo: productSearchBar!.bottomAnchor, constant: padding!),
            categorysCollectionView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding!),
            categorysCollectionView!.heightAnchor.constraint(equalToConstant: navigationBar!.frame.size.height)
        ])
    }
    
    func loadProductsCollectionView() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.itemSize = CGSize(width: cellWidth!, height: cellWidth!*1.5)
        productsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        productsCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        productsCollectionView!.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        productsCollectionView!.delegate = self
        productsCollectionView!.dataSource = self
        productsCollectionView!.showsVerticalScrollIndicator = false
        productsCollectionView!.backgroundColor = UIColor.clear
        self.view.addSubview(productsCollectionView!)
        NSLayoutConstraint.activate([
            productsCollectionView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding!),
            productsCollectionView!.topAnchor.constraint(equalTo: categorysCollectionView!.bottomAnchor, constant: padding!),
            productsCollectionView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding!),
            productsCollectionView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -padding!)
        ])
    }
    
    //MARK: Navigation Click Button Click
    @objc func ClickOnSetting() {
        settingsVC = SettingViewController()
        self.navigationController!.pushViewController(settingsVC!, animated: true)
    }
    
    @objc func ClickOnCartView() {
        productCartVC = ProductCartViewController()
        self.navigationController!.pushViewController(productCartVC!, animated: true)
    }
    
    //MARK: CollectionView Delegate Function
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productsCollectionView {
            if isSearch! {
                return productsSearch!.count
            }else{
                return productsModel!.count
            }
        }else{
            return categoryModel!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            if isSearch! {
                cell.updateCellForHomeViewController(products: productsSearch![indexPath.row])
            }else{
                cell.updateCellForHomeViewController(products: productsModel![indexPath.row])
            }
            return cell
        }else{
            let cell : CategorysCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorysCollectionViewCell", for: indexPath) as! CategorysCollectionViewCell
            cell.backgroundColor = UIColor.clear
            cell.updateCellForCategory(category: categoryModel![indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productsCollectionView {
            cellIndex = indexPath.row
            productDetailsVC = ProductsDetailViewController()
            if isSearch! {
                productDetailsVC!.productsModel = productsSearch![indexPath.row]
            }else{
                productDetailsVC!.productsModel = productsModel![indexPath.row]
            }
            productDetailsVC!.productModel = productsModel
            productDetailsVC!.cellIndex = cellIndex
            self.navigationController!.pushViewController(productDetailsVC!, animated: true)
        }else{
            categoryVC = CategoryViewController()
            categoryVC!.categoryString = categoryModel![indexPath.row]
            self.navigationController!.pushViewController(categoryVC!, animated: true)
            print(categoryModel![indexPath.row])
        }
    }
    
    //MARK: SearhcBarView Delegate Function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = true
        if searchText.isEmpty {
            productsSearch = productsModel
            searchBar.resignFirstResponder()
        } else {
            productsSearch = productsModel?.filter { (product) -> Bool in
                return product.category!.range(of: searchText, options: .caseInsensitive) != nil || product.title!.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
        productsCollectionView!.reloadData()
    }
    
    func getProductsData() {
        productsParser = ProductsParser()
        productsParser!.delegate = self
        productsParser!.getProductsDetails()
    }
    
    func didReceivedProducts(products: [ProductsModel]) {
        productsModel = products
        loadProductsCollectionView()
        activityIndicator.stopAnimating()
    }
    
    func getCategoryData() {
        categoryParser = CategoriesParser()
        categoryParser!.delegate = self
        categoryParser!.getCategorysDetail()
        getProductsData()
    }
    
    func didReceivedCategorys(categorys: [String]) {
        categoryModel = categorys
        loadCategorysCollectionView()
    }
    
    func didReceivedError() {
        print("Products Details vError")
    }
    
}
