//
//  SignUpViewController.swift
//  ShopNow
//
//  Created by mayank ranka on 29/06/23.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
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
    
    var passwordView          : UIView?
    var passwordTextField     : UITextField?
    
    var signUpButton          : UIButton?
    var signInLabel           : UILabel?
    
    
    var signInViewController  : ViewController?
    var deviceManager         : DeviceManager?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    
    var activityIndicator     = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: AppConstant.backgroundColor)
        signUpIndicator()
        loadDeviceManager()
        loadBaseView()
        signUpIndicator()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        addressView!.addSubview(addressTextField!)
        NSLayoutConstraint.activate([
            addressTextField!.leadingAnchor.constraint(equalTo: addressView!.leadingAnchor, constant: padding!),
            addressTextField!.topAnchor.constraint(equalTo: addressView!.topAnchor, constant: padding!),
            addressTextField!.trailingAnchor.constraint(equalTo: addressView!.trailingAnchor, constant: -padding!),
            addressTextField!.bottomAnchor.constraint(equalTo: addressView!.bottomAnchor, constant: -padding!)
        ])
        
        passwordView = AppConstant.setCardBackgroud(heightAnchor: 45, stackView: mainStackView!)
        passwordTextField = UITextField()
        passwordTextField!.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField!.tintColor = UIColor(hexString: AppConstant.textLabelColor)
        passwordTextField!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        passwordTextField!.placeholder = "Password"
        passwordTextField!.font = UIFont.systemFont(ofSize: fontSize!)
        passwordTextField!.delegate = self
        passwordTextField!.backgroundColor = UIColor.clear
        passwordTextField!.isSecureTextEntry = true
        passwordView!.addSubview(passwordTextField!)
        NSLayoutConstraint.activate([
            passwordTextField!.leadingAnchor.constraint(equalTo: passwordView!.leadingAnchor, constant: padding!),
            passwordTextField!.topAnchor.constraint(equalTo: passwordView!.topAnchor, constant: padding!),
            passwordTextField!.trailingAnchor.constraint(equalTo: passwordView!.trailingAnchor, constant: -padding!),
            passwordTextField!.bottomAnchor.constraint(equalTo: passwordView!.bottomAnchor, constant: -padding!)
        ])
        
        signUpLabel = UILabel()
        signUpLabel!.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel!.text = "Register"
        signUpLabel!.font = UIFont.boldSystemFont(ofSize: 45)
        signUpLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        signUpLabel!.textAlignment = .center
        self.view.addSubview(signUpLabel!)
        NSLayoutConstraint.activate([
            signUpLabel!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signUpLabel!.bottomAnchor.constraint(equalTo: mainStackView!.topAnchor, constant: -padding!*5)
        ])
        
        signUpButton = UIButton()
        signUpButton!.translatesAutoresizingMaskIntoConstraints  = false
        signUpButton!.setTitle("Register", for: .normal)
        signUpButton!.titleLabel!.font = UIFont.boldSystemFont(ofSize: fontSize!)
        signUpButton!.backgroundColor = UIColor(hexString: AppConstant.navigationColor)
        signUpButton!.layer.borderWidth = 1
        signUpButton!.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        signUpButton!.setTitleColor(UIColor(hexString: AppConstant.secondaryTextColor), for: .normal)
        signUpButton!.layer.cornerRadius = padding!
        signUpButton!.addTarget(self, action: #selector(signUpButtonClick), for: .touchDown)
        self.view.addSubview(signUpButton!)
        NSLayoutConstraint.activate([
            signUpButton!.heightAnchor.constraint(equalToConstant: 40),
            signUpButton!.widthAnchor.constraint(equalToConstant: 120),
            signUpButton!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signUpButton!.topAnchor.constraint(equalTo: mainStackView!.bottomAnchor, constant: padding!*5)
        ])
        
        signInLabel = UILabel()
        signInLabel!.translatesAutoresizingMaskIntoConstraints = false
        signInLabel!.text = "Already have an account? Login"
        signInLabel!.font = UIFont.systemFont(ofSize: fontSize!*1.1)
        signInLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        signInLabel!.textAlignment = .center
        signInLabel!.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(OnClick))
        signInLabel!.addGestureRecognizer(tapGesture)
        self.view.addSubview(signInLabel!)
        NSLayoutConstraint.activate([
            signInLabel!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInLabel!.topAnchor.constraint(equalTo: signUpButton!.bottomAnchor, constant: padding!*2)
        ])
    }
    
    func signUpIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = UIColor(hexString: AppConstant.activityIndicator)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func isEmptyTextField() {
        self.nameTextField!.text = ""
        self.emailTextField!.text = ""
        self.mobileNoTextField!.text = ""
        self.addressTextField!.text = ""
        self.passwordTextField!.text = ""
    }
    
    @objc func signUpButtonClick() {
        if nameTextField!.text != "" && emailTextField!.text != "" && mobileNoTextField!.text != "" && addressTextField!.text != "" && passwordTextField!.text != "" {
            emailPasswordValidation()
        }else{
            makeAlert(title: "Empty", message: "Please Enter Your Details", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                print("OK")
            }])
        }
    }
    
    func emailPasswordValidation() {
        if !emailTextField!.text!.isValidateEmailId(){
            makeAlert(title: "Invalid Email", message: "Please Enter Valid Email", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                self.isEmptyTextField()
            }])
        }else if !passwordTextField!.text!.isValidPassword(){
            makeAlert(title: "Invalid Password Pattern", message: "Please Enter Minimum 8 characters at least 1 Uppercase and Lowercase Alphabet, 1 Number and 1 Special Character", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
//                self.isEmptyTextField()
            }])
        }else{
            activityIndicator.startAnimating()
            signUpAuthentication()
        }
    }
    
    func signUpAuthentication() {
        Auth.auth().createUser(withEmail: emailTextField!.text!, password: passwordTextField!.text!) { (authData, error) in
            if error != nil{
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "Something Went Wrong", message: error!.localizedDescription, alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    self.isEmptyTextField()
                }])
            }else{
                self.storeUserData()
            }
        }
    }
    
    func storeUserData() {
        let db = Firestore.firestore()
        let userData: [String: Any] = ["userName": self.nameTextField!.text!, "userEmail": self.emailTextField!.text!, "mobileNumber": self.mobileNoTextField!.text!, "password": self.passwordTextField!.text!, "address": self.addressTextField!.text!]
        db.collection("userDetails").document(Auth.auth().currentUser!.uid).setData(userData) { [self] err in
            if let err = err {
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "Something Went Wrong", message: "Error writing document: \(err)", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    self.isEmptyTextField()
                }])
            } else {
                self.activityIndicator.stopAnimating()
                self.isEmptyTextField()
                self.makeAlert(title: "Successfully", message: "SignUp Successfully", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    signInViewController = ViewController()
                    self.navigationController!.pushViewController(signInViewController!, animated: true)
                }])
            }
        }
    }
    
    @objc func OnClick() {
        signInViewController = ViewController()
        self.navigationController!.pushViewController(signInViewController!, animated: true)
    }
}
