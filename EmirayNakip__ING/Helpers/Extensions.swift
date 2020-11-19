//
//  Extensions.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 16.11.2020.
//

import Foundation
import UIKit


let viewSpinner : UIView = UIView()
var activityindicatorView : UIActivityIndicatorView?

let viewAlert : UIView = UIView()

extension UIViewController {

    // ************* SPINNER BEGIN
    func startActivityIndicator(mainView: UIView) {
        
        viewSpinner.backgroundColor = Colors().banabiColor.withAlphaComponent(0.5)
        viewSpinner.translatesAutoresizingMaskIntoConstraints = false
        viewSpinner.layer.masksToBounds = true
        viewSpinner.layer.cornerRadius = 8.0
        mainView.addSubview(viewSpinner)
        
        viewSpinner.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        viewSpinner.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        viewSpinner.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0.0).isActive = true
        viewSpinner.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: -44.0).isActive = true
        
        activityindicatorView = UIActivityIndicatorView.init()
        if #available(iOS 13, *) {
            activityindicatorView?.style = .large
        } else {
            activityindicatorView?.style = .whiteLarge
        }
        activityindicatorView?.color = .white
        activityindicatorView?.translatesAutoresizingMaskIntoConstraints = false
        activityindicatorView?.startAnimating()
        viewSpinner.addSubview(activityindicatorView!)
        
        activityindicatorView!.centerXAnchor.constraint(equalTo: viewSpinner.centerXAnchor, constant: 0.0).isActive = true
        activityindicatorView!.centerYAnchor.constraint(equalTo: viewSpinner.centerYAnchor, constant: 0.0).isActive = true
    }
    
    func stopActivityIndicator() {
        activityindicatorView?.stopAnimating()
        activityindicatorView?.removeFromSuperview()
        viewSpinner.removeFromSuperview()
    }
    //  SPINNER END *******************************
    
    // FIND ***********
    func find(value searchValue: Int, in array: [Int]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }

        return nil
    }
    // ****************
    
    // ************** SHOW ALERT
    func showAlert(msgg: String, imagename: String) {
        // VIEW ALERT **********
        viewAlert.backgroundColor = .clear
        viewAlert.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewAlert)
        
        viewAlert.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        viewAlert.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        viewAlert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        viewAlert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        // *********************
        
        // VIEW MESG **********
        let viewMesg : UIView = UIView()
        viewMesg.backgroundColor = Colors().banabiColor
        viewMesg.layer.cornerRadius = 10.0
        viewMesg.layer.masksToBounds = true
        viewMesg.translatesAutoresizingMaskIntoConstraints = false
        viewAlert.addSubview(viewMesg)
        
        viewMesg.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        viewMesg.widthAnchor.constraint(equalToConstant: viewAlert.frame.size.width).isActive = true
        viewMesg.leadingAnchor.constraint(equalTo: viewAlert.leadingAnchor, constant: 0.0).isActive = true
        viewMesg.trailingAnchor.constraint(equalTo: viewAlert.trailingAnchor, constant: 0.0).isActive = true
        viewMesg.bottomAnchor.constraint(equalTo: viewAlert.bottomAnchor, constant: 0.0).isActive = true
        // *********************
        
        // IMAGE VIEW ALERT **********
        let imageviewAlert : UIImageView = UIImageView()
        imageviewAlert.image = UIImage.init(named: imagename)
        imageviewAlert.translatesAutoresizingMaskIntoConstraints = false
        viewAlert.addSubview(imageviewAlert)
        
        imageviewAlert.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        imageviewAlert.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        imageviewAlert.centerXAnchor.constraint(equalTo: viewAlert.centerXAnchor, constant: 0.0).isActive = true
        imageviewAlert.centerYAnchor.constraint(equalTo: viewAlert.centerYAnchor, constant: 0.0).isActive = true
        // *********************
        
        // LABEL MSG **********
        let label : UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = .white
        label.textAlignment = .center
        label.text = msgg
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        viewMesg.addSubview(label)
        
        label.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        label.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
        label.centerXAnchor.constraint(equalTo: viewMesg.centerXAnchor, constant: 0.0).isActive = true
        label.centerYAnchor.constraint(equalTo: viewMesg.centerYAnchor, constant: -5.0).isActive = true
        // *********************
        
        let button : UIButton = UIButton()
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 6.0
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(removeAlertView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        viewMesg.addSubview(button)
        
        button.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        button.bottomAnchor.constraint(equalTo: viewMesg.bottomAnchor, constant: -5.0).isActive = true
        button.centerXAnchor.constraint(equalTo: viewMesg.centerXAnchor, constant: 0.0).isActive = true
    }
    
    @objc func removeAlertView() {
        viewAlert.removeFromSuperview()
    }
    // END ALERT ***************
}

extension UIBarButtonItem {

    static func barButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
}

//MARK: - STRING
extension String {
    
    func convertMyDateFormat() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        
        if let date = dateFormatterGet.date(from: self) {
            print(dateFormatterPrint.string(from: date))
            return dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
            return ""
        }
    }
    
}

//MARK: - UICOLOR
extension UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1)
    }
    
    convenience init(hex: Int, alpha: Double) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: CGFloat(alpha))
    }
}

//MARK: - UITEXTFIELD
extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
