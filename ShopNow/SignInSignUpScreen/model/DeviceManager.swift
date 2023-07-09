//
//  DeviceManager.swift
//  ShopNow
//
//  Created by mayank ranka on 26/06/23.
//

import UIKit

class DeviceManager: NSObject {
    var deviceOrientation = -1;
    var deviceType: Int = -1;
    
    let iPhone      =   0
    let iPad        =   1
    let iPhone5     =   2
    let iPhone6     =   3
    let iPhone6plus =   4
    let iPhoneX     =   5
    let iPad_10_5   =   6
    let iPad_12_9   =   7
    
    let LANDSCAPE   =   1
    let POTRAIT     =   2
    
    let screenHeight    =   UIScreen.main.bounds.size.height
    let screenWidth     =   UIScreen.main.bounds.size.width
    let screenHeightFloat : Float   =   Float(UIScreen.main.bounds.size.height)
    let screenWidthFloat  : Float  =   Float(UIScreen.main.bounds.size.width)
    
    static var instance : DeviceManager = {
        let instance1 = DeviceManager()
        return instance1
    }()
    
    private override init() {
        super.init()
        
        deviceType = getDeviceType()
        
        switch (UIApplication.shared.statusBarOrientation)
        {
        case .portrait:
            deviceOrientation   =   POTRAIT
        case .portraitUpsideDown:
            deviceOrientation   =   POTRAIT
        case .landscapeLeft:
            deviceOrientation   =   LANDSCAPE
        case .landscapeRight:
            deviceOrientation   =   LANDSCAPE
        default:
            deviceOrientation   =   POTRAIT
        }
    }
    
    func isiPhone() -> Bool {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return false
        } else {
            return true
        }
    }
    
    func getDeviceType() -> Int {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if screenWidth == 834.0 && screenHeight == 1112.0 {
                return iPad_10_5;
            } else if screenWidth == 1024.0 && screenHeight == 1366.0 {
                return iPad_12_9;
            } else {
                return iPad;
            }
        } else {
            if screenWidth == 375.0 && screenHeight == 667.0 {
                return iPhone6;
            } else if screenWidth == 414.0 && screenHeight == 736.0 {
                return iPhone6plus;
            } else if screenWidth == 375.0 && screenHeight == 812.0{
                return iPhoneX
            } else if screenHeight == 568.0 {
                return iPhone5;
            } else {
                return iPhone;
            }
        }
    }
    
    func resourceNameAsPerDevice(fileName : String!) -> String! {
        var actualFileName : String! = nil
        
        switch (deviceType) {
        case iPhone:
            return fileName!;
        case iPad:
            actualFileName = "\(fileName!)_ipad"
            return actualFileName;
        case iPad_10_5:
            actualFileName = "\(fileName!)_ipad_10_5"
            return actualFileName;
        case iPad_12_9:
            actualFileName = "\(fileName!)_ipad_12_9"
            return actualFileName;
        case iPhone5:
            actualFileName = "\(fileName!)_5"
            return actualFileName;
        case iPhone6:
            actualFileName = "\(fileName!)_6"
            return actualFileName;
        case iPhone6plus:
            actualFileName = "\(fileName!)_6plus"
            return actualFileName;
        case iPhoneX:
            actualFileName = "\(fileName!)_X"
            return actualFileName;
        default:
            return fileName!;
        }
    }
    
    func deviceXvalue(xPos : Float) -> Float {
        var actualXPos : Float = 0.0
        
        if deviceType == iPhone {
            return xPos;
        } else {
            if(deviceOrientation == POTRAIT) {
                actualXPos = (screenWidthFloat/320.0) * xPos;
                return actualXPos;
            } else {
                actualXPos = (screenHeightFloat/480.0) * xPos;
                return actualXPos;
            }
        }
    }
    
    func deviceYvalue(yPos : Float) -> Float {
        var actualYPos : Float = 0.0
        
        if deviceType == iPhone {
            return yPos;
        } else {
            if(deviceOrientation == POTRAIT) {
                actualYPos = (screenHeightFloat/480.0) * yPos;
                return actualYPos;
            } else {
                actualYPos = (screenWidthFloat/320.0) * yPos;
                return actualYPos;
            }
        }
    }
    
    func deviceXCGFloatValue(xPos : CGFloat) -> CGFloat {
        var actualXPos : CGFloat = 0.0
        
        if deviceType == iPhone {
            return xPos;
        } else {
            if(deviceOrientation == POTRAIT) {
                actualXPos = (screenWidth/320.0) * xPos;
                return actualXPos;
            } else {
                actualXPos = (screenHeight/480.0) * xPos;
                return actualXPos;
            }
        }
    }
    
    func deviceYCGFloatValue(yPos : CGFloat) -> CGFloat {
        var actualYPos : CGFloat = 0.0
        
        if deviceType == iPhone {
            return yPos;
        } else {
            if(deviceOrientation == POTRAIT) {
                actualYPos = (screenHeight/480.0) * yPos;
                return actualYPos;
            } else {
                actualYPos = (screenWidth/320.0) * yPos;
                return actualYPos;
            }
        }
    }
    
    func iOSVersionFamily () -> Float {
        /*
         we don't want exact version but want to check iOS 6,7 or 8 thus using
         */
        let floatVersion = (UIDevice.current.systemVersion as NSString).floatValue
        return floatVersion
    }
}
