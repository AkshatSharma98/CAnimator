//
//  Commons.swift
//  CAnimator
//
//  Created by Akshat Sharma on 23/01/22.
//

import Foundation
import UIKit

final class Commons {
    
    static func getTopVC(controller: UIViewController? = Commons.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return getTopVC(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return getTopVC(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return getTopVC(controller: presented)
        }
        return controller
    }
    
    static func isiPhoneXOrBigger() -> Bool {
        return UIScreen.main.bounds.height >= 812
    }
    
    static func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = Commons.keyWindow
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    static func getNotchHeight() -> CGFloat {
        if Commons.isiPhoneXOrBigger() {
            return 24
        } else {
            return 0
        }
    }
    
    static func getColorFromHex(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    private static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
               .filter { $0.activationState == .foregroundActive }
               .first(where: { $0 is UIWindowScene })
               .flatMap({ $0 as? UIWindowScene })?.windows
               .first(where: \.isKeyWindow)
    }
    
    static func getTopPaddingForView() -> CGFloat {
        return getStatusBarHeight() + 44
    }
}
