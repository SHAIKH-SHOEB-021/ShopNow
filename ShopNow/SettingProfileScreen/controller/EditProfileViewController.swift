//
//  EditProfileViewController.swift
//  ShopNow
//
//  Created by mayank ranka on 03/07/23.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    var deviceManager         : DeviceManager?
    var navigationBar         : UINavigationBar?
    
    var mainStackView         : UIStackView?
    var signUpLabel           : UILabel?
    
    var nameView              : UIView?
    var nameTextField         : UITextField?
    
    var emailView             : UIView?
    var emailTextField        : UITextField?
    
    var mobileNoView          : UIView?
    var mobileNoTextField     : UITextField?
    
    var addressView           : UIView?
    var addressTextField      : UITextField?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    var cellWidth             : CGFloat?
    var imageHieght           : CGFloat?
    
    var updateButton          : UIButton?
    var signInLabel           : UILabel?
    
    var uid                   : String?
    
    var navigationTitle       : String?
    
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "View Profile"
        uid = UserDefaults.standard.string(forKey: "userID")
        self.view.backgroundColor = UIColor(hexString: AppConstant.backgroundColor)
        loadDeviceManager()
        loadStatusBar()
        loadNavigationBar()
        loadBaseView()
        editProfileIndicator()
        fetchUserData()
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
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = navigationTitle!
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(backButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(userDataEditEnable))
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
    
    func editProfileIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = UIColor(hexString: AppConstant.activityIndicator)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func loadBaseView() {
        mainStackView = UIStackView()
        mainStackView!.translatesAutoresizingMaskIntoConstraints = false
        mainStackView!.axis = NSLayoutConstraint.Axis.vertical
        mainStackView!.spacing = padding!*3
        self.view.addSubview(mainStackView!)
        NSLayoutConstraint.activate([
            mainStackView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding!*2),
            mainStackView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding!*2),
            mainStackView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        nameView = AppConstant.setCardBackgroud(heightAnchor: 45, stackView: mainStackView!)
        nameTextField = UITextField()
        nameTextField!.translatesAutoresizingMaskIntoConstraints = false
        nameTextField!.tintColor = UIColor(hexString: AppConstant.textLabelColor)
        nameTextField!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        nameTextField!.placeholder = "Full Name"
        nameTextField!.font = UIFont.systemFont(ofSize: fontSize!)
        nameTextField!.delegate = self
        nameTextField!.backgroundColor = UIColor.clear
        nameTextField!.isUserInteractionEnabled = false
        nameView!.addSubview(nameTextField!)
        NSLayoutConstraint.activate([
            nameTextField!.leadingAnchor.constraint(equalTo: nameView!.leadingAnchor, constant: padding!),
            nameTextField!.topAnchor.constraint(equalTo: nameView!.topAnchor, constant: padding!),
            nameTextField!.trailingAnchor.constraint(equalTo: nameView!.trailingAnchor, constant: -padding!),
            nameTextField!.bottomAnchor.constraint(equalTo: nameView!.bottomAnchor, constant: -padding!)
        ])
        
        emailView = AppConstant.setCardBackgroud(heightAnchor: 45, stackView: mainStackView!)
        emailTextField = UITextField()
        emailTextField!.translatesAutoresizingMaskIntoConstraints = false
        emailTextField!.tintColor = UIColor(hexString: AppConstant.textLabelColor)
        emailTextField!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        emailTextField!.placeholder = "E-mail"
        emailTextField!.font = UIFont.systemFont(ofSize: fontSize!)
        emailTextField!.delegate = self
        emailTextField!.backgroundColor = UIColor.clear
        emailTextField!.keyboardType = .emailAddress
        emailTextField!.isUserInteractionEnabled = false
        emailView!.addSubview(emailTextField!)
        NSLayoutConstraint.activate([
            emailTextField!.leadingAnchor.constraint(equalTo: emailView!.leadingAnchor, constant: padding!),
            emailTextField!.topAnchor.constraint(equalTo: emailView!.topAnchor, constant: padding!),
            emailTextField!.trailingAnchor.constraint(equalTo: emailView!.trailingAnchor, constant: -padding!),
            emailTextField!.bottomAnchor.constraint(equalTo: emailView!.bottomAnchor, constant: -padding!)
        ])
        
        mobileNoView = AppConstant.setCardBackgroud(heightAnchor: 45, stackView: mainStackView!)
        mobileNoTextField = UITextField()
        mobileNoTextField!.translatesAutoresizingMaskIntoConstraints = false
        mobileNoTextField!.tintColor = UIColor(hexString: AppConstant.textLabelColor)
        mobileNoTextField!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        mobileNoTextField!.placeholder = "Mobile No"
        mobileNoTextField!.font = UIFont.systemFont(ofSize: fontSize!)
        mobileNoTextField!.delegate = self
        mobileNoTextField!.backgroundColor = UIColor.clear
        mobileNoTextField!.keyboardType = .numberPad
        mobileNoTextField!.isUserInteractionEnabled = false
        mobileNoView!.addSubview(mobileNoTextField!)
        NSLayoutConstraint.activate([
            mobileNoTextField!.leadingAnchor.constraint(equalTo: mobileNoView!.leadingAnchor, constant: padding!),
            mobileNoTextField!.topAnchor.constraint(equalTo: mobileNoView!.topAnchor, constant: padding!),
            mobileNoTextField!.trailingAnchor.constraint(equalTo: mobileNoView!.trailingAnchor, constant: -padding!),
            mobileNoTextField!.bottomAnchor.constraint(equalTo: mobileNoView!.bottomAnchor, constant: -padding!)
        ])
        
        addressView = AppConstant.setCardBackgroud(heightAnchor: 45, stackView: mainStackView!)
        addressTextField = UITextField()
        addressTextField!.translatesAutoresizingMaskIntoConstraints = false
        addressTextField!.tintColor = UIColor(hexString: AppConstant.textLabelColor)
        addressTextField!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        addressTextField!.placeholder = "Address"
        addressTextField!.font = UIFont.systemFont(ofSize: fontSize!)
        addressTextField!.delegate = self
        addressTextField!.backgroundColor = UIColor.clear
        addressTextField!.isUserInteractionEnabled = false
        addressView!.addSubview(addressTextField!)
        NSLayoutConstraint.activate([
            addressTextField!.leadingAnchor.constraint(equalTo: addressView!.leadingAnchor, constant: padding!),
            addressTextField!.topAnchor.constraint(equalTo: addressView!.topAnchor, constant: padding!),
            addressTextField!.trailingAnchor.constraint(equalTo: addressView!.trailingAnchor, constant: -padding!),
            addressTextField!.bottomAnchor.constraint(equalTo: addressView!.bottomAnchor, constant: -padding!)
        ])
        
        updateButton = UIButton()
        updateButton!.translatesAutoresizingMaskIntoConstraints  = false
        updateButton!.setTitle("Update", for: .normal)
        updateButton!.titleLabel!.font = UIFont.boldSystemFont(ofSize: fontSize!)
        updateButton!.backgroundColor = UIColor(hexString: AppConstant.navigationColor)
        updateButton!.layer.borderWidth = 1
        updateButton!.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        updateButton!.setTitleColor(UIColor(hexString: AppConstant.secondaryTextColor), for: .normal)
        updateButton!.layer.cornerRadius = padding!
        updateButton!.addTarget(self, action: #selector(clickOnUpdateProfile), for: .touchDown)
        updateButton!.isHidden = true
        self.view.addSubview(updateButton!)
        NSLayoutConstraint.activate([
            updateButton!.heightAnchor.constraint(equalToConstant: 40),
            updateButton!.widthAnchor.constraint(equalToConstant: 120),
            updateButton!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            updateButton!.topAnchor.constraint(equalTo: mainStackView!.bottomAnchor, constant: padding!*5)
        ])
    }
    
    @objc func backButton() {
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func clickOnUpdateProfile() {
        activityIndicator.startAnimating()
        let db = Firestore.firestore()
        let docRef = db.collection("userDetails").document(uid!)
        let userData: [String: Any] = ["userName": self.nameTextField!.text!, "userEmail": self.emailTextField!.text!, "mobileNumber": self.mobileNoTextField!.text!, "address": self.addressTextField!.text!]
        docRef.updateData(userData) {error in
            if let error = error {
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "Something Went Wrong", message: "Error updating document: \(error.localizedDescription)", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    userInterationEnable(isEnable: false)
                }])
            } else {
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "Successfully", message: "Profile Update Successfully", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    userInterationEnable(isEnable: false)
                    updateButton!.isHidden = true
                    navigationTitle = "View Profile"
                    loadNavigationBar()
                }])
            }
        }
    }
    
    func fetchUserData() {
        activityIndicator.startAnimating()
        let db = Firestore.firestore()
        let docRef = db.collection("userDetails").document(uid!)
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "Something Went Wrong", message: "Error getting document: \(error.localizedDescription)", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    self.navigationController!.popViewController(animated: true)
                }])
            }
            else {
                if let document = document {
                    let id = document.documentID
                    let data = document.data()
                    let name = data?["userName"] as? String ?? ""
                    let email = data?["userEmail"] as? String ?? ""
                    let mobile = data?["mobileNumber"] as? String ?? ""
                    let address = data?["address"] as? String ?? ""
                    self.configureUserData(name: name, email: email, mobile: mobile, address: address)
                }
            }
        }
    }
    
    func configureUserData(name: String, email: String, mobile: String, address: String) {
        nameTextField!.text = name
        emailTextField!.text = email
        mobileNoTextField!.text = mobile
        addressTextField!.text = address
        activityIndicator.stopAnimating()
    }
    
    func userInterationEnable(isEnable: Bool) {
        nameTextField!.isUserInteractionEnabled = isEnable
        emailTextField!.isUserInteractionEnabled = isEnable
        mobileNoTextField!.isUserInteractionEnabled = isEnable
        addressTextField!.isUserInteractionEnabled = isEnable
        updateButton!.isHidden = false
        navigationTitle = "Edit Profile"
        loadNavigationBar()
    }
    
    @objc func userDataEditEnable() {
        userInterationEnable(isEnable: true)
    }

}
