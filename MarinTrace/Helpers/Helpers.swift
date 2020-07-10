//
//  Helpers.swift
//  MarinTrace
//
//  Created by Beck Lorsch on 6/7/20.
//  Copyright © 2020 Marin Trace. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications

//MARK: Structs

struct AlertHelperFunctions {
    
    //function for presenting a simple error from app delegate
    static func presentErrorAlertOnWindow(title: String, message: String, window: UIWindow) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        window.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    //function for presenting a simple error from a view controller
    static func presentAlertOnVC(title: String, message: String, vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
       vc.present(alertController, animated: true, completion: nil)
    }
    
}

struct NotificationScheduler {
    
    static func scheduleNotifications() {
        
        //clear any prexisting notifications and setup notification center
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
                
        //we want notifications for every day, but we also need to be able to cancel today's notification if they fill out their symptoms. This can't be done with a repeating calendar trigger, so we have to create a bunch manually and then remove one via its id
        
        //30 days worth of notifcations
        for i in 1...30 {
            let symptomsContent = UNMutableNotificationContent()
            symptomsContent.title = "Report your symptoms!"
            symptomsContent.body = "Remember to report your symptoms."
            
            //get day n
            let day = Calendar.current.date(byAdding: .day, value: i, to: Date())
            
            var components = Calendar.current.dateComponents([.day, .month, .year, .hour, .month], from: day!)
            components.hour = 8
            components.minute = 0
            components.second = 0
            
            let symptomsTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            //create request with id of date in ISO-8601
            let symptomsRequest = UNNotificationRequest(identifier: DateHelper.stringFromDate(withFormat: "yyyy-MM-dd", date: day!), content: symptomsContent, trigger: symptomsTrigger)
            
            //schedule notification
            center.add(symptomsRequest)
        }
        
    }
    
    /*static func scheduleTestNotifications() {
        
        //clear any prexisting notifications and setup notification center
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
                
        //we want notifications for every day, but we also need to be able to cancel today's notification if they fill out their symptoms. This can't be done with a repeating calendar trigger, so we have to create a bunch manually starting tomorrow. If they report symptoms before the notification sends tomorrow, then all these will be cleared, and a new set starting the next day will be created.
        
        //30 days worth of notifcations
        for i in 1...30 {
            let symptomsContent = UNMutableNotificationContent()
            symptomsContent.title = "Report your symptoms!"
            symptomsContent.body = "Remember to report your symptoms."
            
            //get day n
            let day = Calendar.current.date(byAdding: .minute, value: i, to: Date())
            
            var components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: day!)
            components.second = 0
            
            let symptomsTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            //create request with id of date in ISO-8601
            let symptomsRequest = UNNotificationRequest(identifier: UUID().uuidString, content: symptomsContent, trigger: symptomsTrigger)
            
            //schedule notification
            center.add(symptomsRequest) { (error) in
                print(error)
            }
            
        }
        
    }*/
    
}

struct Colors {
    
    //school colors
    static func colorFor(forSchool school:User.School) -> UIColor {
        if school == .MA {
            return UIColor(hexString: "#BE2828")
        } else {
            return UIColor(hexString: "#017BD6")
        }
    }
    
}

struct DateHelper {
    
    static func stringFromDate(withFormat format:String, date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let string = formatter.string(from: date)
        return string
    }
    
    static func dateFromString(withFormat format: String, string:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: string)
        return date!
    }
    
}

struct FontHelper {
    
    //modified from https://stackoverflow.com/a/58123083/4777497
    static func roundedFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        // Will be SF Compact or standard SF in case of failure.
        let fontSize = size
        if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return UIFont.preferredFont(forTextStyle: .subheadline)
        }
    }
    
}

//MARK: Extensions

//remove duplicates
//https://stackoverflow.com/a/25739498/4777497
extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}

//show/hide spinner
var vSpinner: UIView?

extension UIViewController {
    func showSpinner(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        //spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.color = .gray
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

//rounding certain corners
//https://stackoverflow.com/a/41197790/4777497
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
