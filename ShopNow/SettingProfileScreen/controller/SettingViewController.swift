//
//  SettingViewController.swift
//  ShopNow
//
//  Created by mayank ranka on 02/07/23.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var deviceManager         : DeviceManager?
    
    var navigationBar         : UINavigationBar?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    var backViewHeight        : CGFloat?
    
    var backView              : UIView?
    var circularImage         : UIImageView?
    
    var settingTableView      : UITableView?
    
    var signInViewController  : ViewController?
    var editProfileVC         : EditProfileViewController?
    var orderHistoryVC        : OrderHistoryViewController?
    var productCartVC         : ProductCartViewController?
    
    var settingArray          : [AppConstant]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: AppConstant.backgroundColor)
        settingArray = AppConstant.getSettingsViewControllerProvider()
        loadDeviceManager()
        loadStatusBar()
        loadNavigationBar()
        loadBaseView()
        loadSettingTableView()
       
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
        backViewHeight = self.view.frame.size.height / 5
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(backButton))
        navigationItem.title = "Settings"
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
        backView = UIView()
        backView!.translatesAutoresizingMaskIntoConstraints = false
        backView!.backgroundColor = UIColor(hexString: AppConstant.searchBarColor)
        backView!.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backView!.layer.cornerRadius = padding!*2
        self.view.addSubview(backView!)
        NSLayoutConstraint.activate([
            backView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor),
            backView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backView!.heightAnchor.constraint(equalToConstant: backViewHeight!)
        ])
        
        circularImage = UIImageView()
        circularImage!.translatesAutoresizingMaskIntoConstraints = false
        circularImage!.image = UIImage(named: "person.jpg")
        circularImage!.layer.cornerRadius = backViewHeight!*0.7/2
        circularImage!.layer.masksToBounds = true
        circularImage!.contentMode = .scaleToFill
        backView!.addSubview(circularImage!)
        NSLayoutConstraint.activate([
            circularImage!.heightAnchor.constraint(equalToConstant: backViewHeight!*0.7),
            circularImage!.widthAnchor.constraint(equalToConstant: backViewHeight!*0.7),
            circularImage!.centerXAnchor.constraint(equalTo: backView!.centerXAnchor),
            circularImage!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: backViewHeight!*0.5)
        ])
    }
    
    func loadSettingTableView() {
        settingTableView = UITableView()
        settingTableView!.translatesAutoresizingMaskIntoConstraints = false
        settingTableView!.backgroundColor = UIColor.clear
        settingTableView!.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        settingTableView!.delegate = self
        settingTableView!.dataSource = self
        settingTableView!.separatorStyle = .none
        self.view.addSubview(settingTableView!)
        NSLayoutConstraint.activate([
            settingTableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding!),
            settingTableView!.topAnchor.constraint(equalTo: circularImage!.bottomAnchor, constant: padding!),
            settingTableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding!),
            settingTableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -padding!)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.updateCellForSettingViewController(settingModel: settingArray![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingNavigation(cellIndex: indexPath.row)
    }
    
    func settingNavigation(cellIndex: Int) {
        switch cellIndex {
        case 0 :
            editProfileVC = EditProfileViewController()
            self.navigationController!.pushViewController(editProfileVC!, animated: true)
            print("Update Profile")
        case 1 :
            productCartVC = ProductCartViewController()
            self.navigationController!.pushViewController(productCartVC!, animated: true)
            print("View Add To Cart")
        case 2 :
            orderHistoryVC = OrderHistoryViewController()
            self.navigationController!.pushViewController(orderHistoryVC!, animated: true)
            print("View Order History")
        case 3 :
            print("Logout")
            ClickOnSignOut()
        default:
            return
        }
    }
    
    func ClickOnSignOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(nil, forKey: "userToken")
            signInViewController = ViewController()
            self.navigationController!.pushViewController(signInViewController!, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            self.makeAlert(title: "Something went wrong", message: signOutError as! String, alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                print("OK")
            }])
        }
    }
    
    @objc func backButton() {
        self.navigationController!.popViewController(animated: true)
    }

}
