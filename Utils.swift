//
//  Utils.swift
//  WAYW
//
//  Created by Niklas Alvaeus on 25/11/2015.
//

import Foundation
import UIKit



final class Utils {
    
    // Used for events
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()
    
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
                StaticVar.timeformatterShort?.dateStyle = .medium;
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
    
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    func shortDate() -> String {
        let dateString = Date.shortFormatter.string(from: self)
        return dateString
    }
    
    static let eventFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    func eventDate() -> String {
        let dateString = Date.eventFormatter.string(from: self)
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

extension String {
    
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
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



public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
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

import UIKit

extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setStroke()

        let cross = UIBezierPath()
        cross.move(to: CGPoint(x: 0, y: size.height - lineWidth)) // your point
        cross.addLine(to: CGPoint(x: size.width, y: size.height - lineWidth)) // your point
        cross.close()
        cross.lineWidth = lineWidth
        cross.lineCapStyle = .butt
        cross.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension String {
    
    var html2AttributedString: NSAttributedString? {
        do {
            let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


class LeftAlignedSearchBar: UISearchBar, UISearchBarDelegate {
    override var placeholder:String? {
        didSet {
            if let text = placeholder {
                if text.characters.last! != " " {
                    // get the font attribute
                    let attr = UITextField.appearance(whenContainedInInstancesOf: [LeftAlignedSearchBar.self]).defaultTextAttributes
                    // define a max size
                    let maxSize = CGSize(width: UIScreen.main.bounds.size.width - 87, height: 40)
                    // let maxSize = CGSize(width:self.bounds.size.width - 92,height: 40)
                    // get the size of the text
                    let widthText = text.boundingRect( with: maxSize, options: .usesLineFragmentOrigin, attributes:attr, context:nil).size.width
                    // get the size of one space
                    let widthSpace = " ".boundingRect( with: maxSize, options: .usesLineFragmentOrigin, attributes:attr, context:nil).size.width
                    let spaces = floor((maxSize.width - widthText) / widthSpace)
                    // add the spaces
                    let newText = text + ((Array(repeating: " ", count: Int(spaces)).joined(separator: "")))
                    // apply the new text if nescessary
                    if newText != text {
                        placeholder = newText
                    }
                }
            }
        }
    }
}

extension UILabel {
    func setLineHeight(_ lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
