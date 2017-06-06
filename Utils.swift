//
//  Utils.swift
//  WAYW
//
//  Created by Niklas Alvaeus on 25/11/2015.
//

import Foundation
import UIKit



final class Utils {
    

    private struct StaticVar { static var timeformatterShort: DateFormatter? }
    
    class func timeStringFromDate(date: Date) -> String {
        let timeInterval = fabs(date.timeIntervalSinceNow)
        if timeInterval < 60 {
            return "just now"
        }
        
        if (timeInterval >= 60 && timeInterval < (60 * 2)) {
            return NSString(format: "%.0f minute ago", timeInterval/60.0) as String
        }
        
        if (timeInterval < 3600) {
            return NSString(format: "%.0f minutes ago", timeInterval / 60.0) as String
        }
        
        if (timeInterval >= 3600 && timeInterval < (3600 * 2)) {
            return NSString(format: "%.0f hour ago", timeInterval / 3600.0) as String
        }
        
        if (timeInterval < 3600 * 24) {
            return NSString(format: "%.0f hours ago", timeInterval / 3600.0) as String
        }
        
        if (timeInterval >= 3600 * 24 && timeInterval < (3600 * 24 * 1)) {
            return NSString(format: "%.0f day ago", timeInterval / (3600.0 * 24.0)) as String
        }
        
        if (timeInterval > 3600 * 24 * 7) {
            if (StaticVar.timeformatterShort == nil) {
                StaticVar.timeformatterShort = DateFormatter()
                StaticVar.timeformatterShort?.timeStyle = .none;
                StaticVar.timeformatterShort?.dateStyle = .short;
            }
            return StaticVar.timeformatterShort!.string(from: date)
        }
        return NSString(format: "%.0f days ago", timeInterval/(3600.0 * 24.0)) as String
    }
    
    
}

extension Int {
    var ordinal: String {
        get {
            var suffix: String = ""
            let ones: Int = self % 10;
            let tens: Int = (self/10) % 10;
            
            if (tens == 1) {
                suffix = "th";
            } else if (ones == 1){
                suffix = "st";
            } else if (ones == 2){
                suffix = "nd";
            } else if (ones == 3){
                suffix = "rd";
            } else {
                suffix = "th";
            }
            
            return suffix
        }
    }
}

extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    func isoDate() -> String {
        let dateString = Date.iso8601Formatter.string(from: self)
        return dateString
    }
    
    func isoTwitterDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        dateFormat.locale = Locale.current // NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let isoDateString = dateFormat.string(from: self)
        return isoDateString
    }

}

extension String {
    
    func dateFromISOString() -> Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}

extension NSNumber {
    func suffixNumber() -> String {
        
        var num:Double = self.doubleValue;
        let sign = ((num < 0) ? "-" : "" );
        
        num = fabs(num);
        
        if (num < 1000.0){
            return "\(sign)\(num)";
        }
        
        let exp:Int = Int(log10(num) / log10(1000));
        
        let units:[String] = ["K","M","B","T","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])";
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension UIColor {
    convenience init(hexString:String) {
        let hexString:String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
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



extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}

extension UILabel {
    func setHTMLFromString(text: String) {
        let modifiedFont = String(format:"<span style=\"color:\(self.textColor.toHexString());font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>", text) as String

        do {
            let attrStr = try NSAttributedString(data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            self.attributedText = attrStr

        } catch {
            print(error)
            self.attributedText = nil
        }
    }
}

extension UITextView {
    func setHTMLFromString(text: String) {
        let modifiedFont = String(format:"<span style=\"color:\(self.textColor?.toHexString());font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>", text) as String
        
        do {
            let attrStr = try NSAttributedString(data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            self.attributedText = attrStr
            
        } catch {
            print(error)
            self.attributedText = nil
        }
    }
}

extension CALayer {
    func image() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        self.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return outputImage!
    }
}

extension Bool {
    init<T : Integer>(_ integer: T){
        self.init(integer != 0)
    }
}



extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width:self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}



extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                         attributes: [NSFontAttributeName: self],
                                                         context: nil).size
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:URL) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
