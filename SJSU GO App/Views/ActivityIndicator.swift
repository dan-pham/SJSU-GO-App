//
//  ActivityIndicator.swift
//  SJSU GO App
//
//  Created by Dan Pham on 11/16/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit

class ActivityIndicator: NSObject {
    
    let blackView = UIView()
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.hidesWhenStopped = true
        indicator.style = .whiteLarge
        return indicator
    }()
    
    let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    func showActivityIndicator(_ vc: UIViewController) {
        print("Show activity indicator: \(vc)")
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = CGRect(x: 0, y: statusBarHeight, width: window.frame.width, height: window.frame.height - statusBarHeight)
            blackView.alpha = 1
            
            activityIndicatorView.center = window.center
            activityIndicatorView.alpha = 1
            
            window.addSubview(blackView)
            window.addSubview(activityIndicatorView)
            
            activityIndicatorView.startAnimating()
        }
    }
    
    func hideActivityIndicator(_ vc: UIViewController) {
        print("Hide activity indicator: \(vc)")
        activityIndicatorView.stopAnimating()
        blackView.removeFromSuperview()
    }
    
}
