//
//  ViewController.swift
//  ShopNow
//
//  Created by shoeb on 26/06/23.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    var signInLabel           : UILabel?
    var mainStackView         : UIStackView?
    
    var emailView             : UIView?
    var emailTextField        : UITextField?
    
    var passwordView          : UIView?
    var passwordTextField     : UITextField?
    
    var signInButton          : UIButton?
    var signUpLabel           : UILabel?
    
    var signUpViewController  : SignUpViewController?
    var homeViewController    : HomeViewController?
    var deviceManager         : DeviceManager?
    
    var padding               : CGFloat?
    var fontSize              : CGFloat?
    
    var activityIndicator     = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: AppConstant.backgroundColor)
        loadDeviceManager()
        loadBaseView()
        signUpIndicator()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        //posY = navigationHeight + UIApplication.shared.statusBarFrame.height + padding
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
        
        signInLabel = UILabel()
        signInLabel!.translatesAutoresizingMaskIntoConstraints = false
        signInLabel!.text = "Login"
        signInLabel!.font = UIFont.boldSystemFont(ofSize: 45)
        signInLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        signInLabel!.textAlignment = .center
        self.view.addSubview(signInLabel!)
        NSLayoutConstraint.activate([
            signInLabel!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInLabel!.bottomAnchor.constraint(equalTo: mainStackView!.topAnchor, constant: -padding!*5)
        ])
        
        signInButton = UIButton()
        signInButton!.translatesAutoresizingMaskIntoConstraints  = false
        signInButton!.setTitle("Login", for: .normal)
        signInButton!.titleLabel!.font = UIFont.boldSystemFont(ofSize: fontSize!)
        signInButton!.backgroundColor = UIColor(hexString: AppConstant.navigationColor)
        signInButton!.layer.borderWidth = 1
        signInButton!.layer.borderColor = UIColor(hexString: AppConstant.borderColor)!.cgColor
        signInButton!.setTitleColor(UIColor(hexString: AppConstant.secondaryTextColor), for: .normal)
        signInButton!.layer.cornerRadius = padding!
        signInButton!.addTarget(self, action: #selector(signInButtonClick), for: .touchDown)
        self.view.addSubview(signInButton!)
        NSLayoutConstraint.activate([
            signInButton!.heightAnchor.constraint(equalToConstant: 40),
            signInButton!.widthAnchor.constraint(equalToConstant: 120),
            signInButton!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInButton!.topAnchor.constraint(equalTo: mainStackView!.bottomAnchor, constant: padding!*5)
        ])
        
        signUpLabel = UILabel()
        signUpLabel!.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel!.text = "Don't have an account? Register"
        signUpLabel!.font = UIFont.systemFont(ofSize: fontSize!*1.1)
        signUpLabel!.textColor = UIColor(hexString: AppConstant.textLabelColor)
        signUpLabel!.textAlignment = .center
        signUpLabel!.isUserInteractionEnabled = true
        signUpLabel!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnSignUp)))
        self.view.addSubview(signUpLabel!)
        NSLayoutConstraint.activate([
            signUpLabel!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signUpLabel!.topAnchor.constraint(equalTo: signInButton!.bottomAnchor, constant: padding!*2)
        ])
    }
    
    func signUpIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = UIColor(hexString: AppConstant.activityIndicator)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    @objc func signInButtonClick() {
        if emailTextField!.text != "" && passwordTextField!.text != ""{
            activityIndicator.startAnimating()
            signInAuthentication()
        }else{
            makeAlert(title: "Empty", message: "Empty Email or Password", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                self.emailTextField!.text = ""
                self.passwordTextField!.text = ""
            }])
        }
    }
    
    func signInAuthentication() {
        Auth.auth().signIn(withEmail: emailTextField!.text!, password: passwordTextField!.text!) { (authData, error) in
            if error != nil {
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "Something Went Wrong", message: error!.localizedDescription, alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    self.emailTextField!.text = ""
                    self.passwordTextField!.text = ""
                }])
            }else {
                guard let user = authData?.user else {
                    return
                }
                UserDefaults.standard.set(user.uid, forKey: "userID")
                UserDefaults.standard.set(user.refreshToken, forKey: "userToken")
                print(user.refreshToken!)
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "Successful", message: "SignIn Successfully", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ [self] _ in
                    self.homeViewController = HomeViewController()
                    self.navigationController!.pushViewController(homeViewController!, animated: true)
                }])
            }
        }
    }
    
    @objc func clickOnSignUp() {
        signUpViewController = SignUpViewController()
        self.navigationController!.pushViewController(signUpViewController!, animated: true)
        
    }
}
