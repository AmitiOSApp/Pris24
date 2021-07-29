//
//  ButtonExtender.swift
//  IBButtonExtender
//
//  Created by Ashish on 08/08/15.
//  Copyright (c) 2015 Ashish. All rights reserved.
//

import UIKit
import QuartzCore
import PasswordTextField

@IBDesignable public class IBView: UIView {
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
               shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
               shadowOpacity: Float = 0.4,
               shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

@IBDesignable public class IBGradientView: IBView {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}

@IBDesignable public class IBStackView: UIStackView {
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

@IBDesignable public class IBButton: UIButton {
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    
}

@IBDesignable class IBGradientButton: IBButton {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}

@IBDesignable public class IBImageView: UIImageView {
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    
}

@IBDesignable public class IBLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 5.0
       @IBInspectable var bottomInset: CGFloat = 5.0
       @IBInspectable var leftInset: CGFloat = 7.0
       @IBInspectable var rightInset: CGFloat = 7.0
  
    override public func drawText(in rect: CGRect) {
          let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
      }

       func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
          intrinsicSuperViewContentSize.height += topInset + bottomInset
          intrinsicSuperViewContentSize.width += leftInset + rightInset
          return intrinsicSuperViewContentSize
      }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var lineHeight: CGFloat = 1.5 {
        didSet {
            let font = UIFont(name: self.font.fontName, size: self.font.pointSize)
            guard let text = self.text else { return }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: NSMakeRange(0, attributedString.length))
            
            self.attributedText = attributedString
        }
    }
    
}

@IBDesignable public class IBTabBar: UITabBar {
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

@IBDesignable class IBTabBarController: UITabBarController {
    
    @IBInspectable var normalTint: UIColor = UIColor.clear {
        didSet {
            UITabBar.appearance().tintColor = normalTint
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normalTint], for: UIControl.State())
        }
    }
    
    @IBInspectable var selectedTint: UIColor = UIColor.clear {
        didSet {
            UITabBar.appearance().tintColor = selectedTint
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedTint], for:UIControl.State.selected)
        }
    }
    
    @IBInspectable var fontName: String = "" {
        didSet {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normalTint, NSAttributedString.Key.font: UIFont(name: fontName, size: 11)!], for: UIControl.State())
        }
    }
    
    @IBInspectable var firstSelectedImage: UIImage? {
        didSet {
            if let image = firstSelectedImage {
                var tabBarItems = self.tabBar.items
                tabBarItems![0].selectedImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            }
        }
    }
    
    @IBInspectable var secondSelectedImage: UIImage? {
        didSet {
            if let image = secondSelectedImage {
                var tabBarItems = self.tabBar.items
                tabBarItems?[1].selectedImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            }
        }
    }
    
    @IBInspectable var thirdSelectedImage: UIImage? {
        didSet {
            if let image = thirdSelectedImage {
                var tabBarItems = self.tabBar.items
                tabBarItems?[2].selectedImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            }
        }
    }
    
    @IBInspectable var fourthSelectedImage: UIImage? {
        didSet {
            if let image = fourthSelectedImage {
                var tabBarItems = self.tabBar.items
                tabBarItems?[3].selectedImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            }
        }
    }
    
    @IBInspectable var fifthSelectedImage: UIImage? {
        didSet {
            if let image = fifthSelectedImage {
                var tabBarItems = self.tabBar.items
                tabBarItems?[4].selectedImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in self.tabBar.items!
        {
            if let image = item.image {
                item.image = image.imageWithColor(tintColor: self.normalTint).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            }
        }
    }
}

@IBDesignable public class IBTextField: UITextField {
    
    @IBInspectable public var placeholderColor: UIColor = UIColor.clear {
        didSet {
            guard let placeholder = placeholder else { return }
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
            layoutSubviews()
            
        }
    }
    
    @IBInspectable public var sidePadding: CGFloat = 0 {
        didSet {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: sidePadding, height: sidePadding))
            
            leftViewMode = UITextField.ViewMode.always
            leftView = padding
            
            rightViewMode = UITextField.ViewMode.always
            rightView = padding
        }
    }
    
    @IBInspectable public var leftPadding: CGFloat = 0 {
        didSet {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 0))
            
            leftViewMode = UITextField.ViewMode.always
            leftView = padding
        }
    }
    
    @IBInspectable public var rightPadding: CGFloat = 0 {
        didSet {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: 0))
            
            rightViewMode = UITextField.ViewMode.always
            rightView = padding
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var lineHeight: CGFloat = 1.5 {
        didSet {
            let font = UIFont(name: self.font!.fontName, size: self.font!.pointSize)
            guard let text = self.text else { return }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: NSRange(location: 0, length: attributedString.length))
            
            self.attributedText = attributedString
        }
    }
    
}

@IBDesignable public class IBPasswordTextField: PasswordTextField {
    
    @IBInspectable public var placeholderColor: UIColor = UIColor.clear {
        didSet {
            guard let placeholder = placeholder else { return }
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
            layoutSubviews()
            
        }
    }
    
    @IBInspectable public var sidePadding: CGFloat = 0 {
        didSet {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: sidePadding, height: sidePadding))
            
            leftViewMode = UITextField.ViewMode.always
            leftView = padding
            
            rightViewMode = UITextField.ViewMode.always
            rightView = padding
        }
    }
    
    @IBInspectable public var leftPadding: CGFloat = 0 {
        didSet {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 0))
            
            leftViewMode = UITextField.ViewMode.always
            leftView = padding
        }
    }
    
    @IBInspectable public var rightPadding: CGFloat = 0 {
        didSet {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: 0))
            
            rightViewMode = UITextField.ViewMode.always
            rightView = padding
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
        
    @IBInspectable public var lineHeight: CGFloat = 1.5 {
        didSet {
            let font = UIFont(name: self.font!.fontName, size: self.font!.pointSize)
            guard let text = self.text else { return }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: NSRange(location: 0, length: attributedString.length))
            
            self.attributedText = attributedString
        }
    }
}

//@IBDesignable public class IBTextView: UITextView {
//    
//    @IBInspectable public var borderColor: UIColor = UIColor.clear {
//        didSet {
//            layer.borderColor = borderColor.cgColor
//        }
//    }
//    
//    @IBInspectable public var borderWidth: CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    
//    @IBInspectable public var cornerRadius: CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//        }
//    }
//    
//    @IBInspectable public var lineHeight: CGFloat = 1.5 {
//        didSet {
//            let font = UIFont(name: self.font!.fontName, size: self.font!.pointSize)
//            guard let text = self.text else { return }
//            
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = lineHeight
//            
//            let attributedString = NSMutableAttributedString(string: text)
//            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
//            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: NSRange(location: 0, length: attributedString.length))
//            
//            self.attributedText = attributedString
//        }
//    }
//    private struct Constants {
//        static let defaultiOSPlaceholderColor: UIColor = {
//            if #available(iOS 13.0, *) {
//                return .systemGray3
//            }
//
//            return UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
//        }()
//    }
//  
//    public let placeholderLabel: UILabel = UILabel()
//    
//    private var placeholderLabelConstraints = [NSLayoutConstraint]()
//    
//    @IBInspectable open var placeholder: String = "" {
//        didSet {
//            placeholderLabel.text = placeholder
//        }
//    }
//    
//    @IBInspectable open var placeholderColor: UIColor = IBTextView.Constants.defaultiOSPlaceholderColor {
//        didSet {
//            placeholderLabel.textColor = placeholderColor
//        }
//    }
//    
//    override open var font: UIFont! {
//        didSet {
//            if placeholderFont == nil {
//                placeholderLabel.font = font
//            }
//        }
//    }
//    
//    open var placeholderFont: UIFont? {
//        didSet {
//            let font = (placeholderFont != nil) ? placeholderFont : self.font
//            placeholderLabel.font = font
//        }
//    }
//    
//    override open var textAlignment: NSTextAlignment {
//        didSet {
//            placeholderLabel.textAlignment = textAlignment
//        }
//    }
//    
//    override open var text: String! {
//        didSet {
//            textDidChange()
//        }
//    }
//    
//    override open var attributedText: NSAttributedString! {
//        didSet {
//            textDidChange()
//        }
//    }
//    
//    override open var textContainerInset: UIEdgeInsets {
//        didSet {
//            updateConstraintsForPlaceholderLabel()
//        }
//    }
//    
//    override public init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        commonInit()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    
//    private func commonInit() {
//        #if swift(>=4.2)
//        let notificationName = UITextView.textDidChangeNotification
//        #else
//        let notificationName = NSNotification.Name.UITextView.textDidChangeNotification
//        #endif
//      
//        NotificationCenter.default.addObserver(self,
//            selector: #selector(textDidChange),
//            name: notificationName,
//            object: nil)
//        
//        placeholderLabel.font = font
//        placeholderLabel.textColor = placeholderColor
//        placeholderLabel.textAlignment = textAlignment
//        placeholderLabel.text = placeholder
//        placeholderLabel.numberOfLines = 0
//        placeholderLabel.backgroundColor = UIColor.clear
//        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(placeholderLabel)
//        updateConstraintsForPlaceholderLabel()
//    }
//    
//    private func updateConstraintsForPlaceholderLabel() {
//        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
//            options: [],
//            metrics: nil,
//            views: ["placeholder": placeholderLabel])
//        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
//            options: [],
//            metrics: nil,
//            views: ["placeholder": placeholderLabel])
//        newConstraints.append(NSLayoutConstraint(
//            item: self,
//            attribute: .height,
//            relatedBy: .greaterThanOrEqual,
//            toItem: placeholderLabel,
//            attribute: .height,
//            multiplier: 1.0,
//            constant: textContainerInset.top + textContainerInset.bottom
//        ))
//        newConstraints.append(NSLayoutConstraint(
//            item: placeholderLabel,
//            attribute: .width,
//            relatedBy: .equal,
//            toItem: self,
//            attribute: .width,
//            multiplier: 1.0,
//            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
//            ))
//        removeConstraints(placeholderLabelConstraints)
//        addConstraints(newConstraints)
//        placeholderLabelConstraints = newConstraints
//    }
//    
//    @objc private func textDidChange() {
//        placeholderLabel.isHidden = !text.isEmpty
//    }
//    
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
//    }
//    
//    deinit {
//      #if swift(>=4.2)
//      let notificationName = UITextView.textDidChangeNotification
//      #else
//      let notificationName = NSNotification.Name.UITextView.textDidChangeNotification
//      #endif
//      
//        NotificationCenter.default.removeObserver(self,
//            name: notificationName,
//            object: nil)
//    }
//}


extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0);
        context!.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context!.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
