//
//  DISegmentedView.swift
//  DISegmentedView
//
//  Created by Nick on 2/2/16.
//  Copyright © 2016 spromicky. All rights reserved.
//
//  Altered by Joyce on 18/05/17

import UIKit

/// Dot indicator segment view.
@IBDesignable
open class DISegmentedView: UIControl {
    
    fileprivate var buttons = [UIButton]()
    fileprivate let baseScrollView = UIScrollView()
    fileprivate let indicator = UIView()
    
    open var titleFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var itemsPerPage: Int = 3 {
        didSet {
            if itemsPerPage > self.titles.count {
                fatalError("DISegmentedView.itemsPerPage cannot exceed DISegmentedView.titles.count")
            }
        }
    }
    
    /// Currently selected segment button.
    open var selectedIndex = 0 {
        didSet {
            animateSelectionTo(selectedIndex, animated: false)
        }
    }
    
    /// Arrays of the titles for segments. Dynamically update instance for new array of title.
    open var titles: [String] = [String]() {
        didSet {
            segmentLength = self.frame.size.width / CGFloat(titles.count + 1)
            selectedIndex = min(titles.count - 1, selectedIndex)
            addButtons()
            setNeedsLayout()
        }
    }
    
    /// Tint color for dot, that indicates selected segment.
    override open var tintColor: UIColor! {
        didSet {
            indicator.backgroundColor = tintColor
        }
    }
    
    /// Diameter of dot, that indicates selected segment.
    @IBInspectable
    open var indicatorWidth: CGFloat = 5 {
        didSet {
            indicator.frame = CGRect(origin: indicator.frame.origin, size: CGSize(width: indicatorWidth, height: indicatorHeight))
            indicator.layer.cornerRadius = indicator.frame.height / 2
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var segmentLength: CGFloat = 5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var indicatorHeight: CGFloat = 5 {
        didSet {
            indicator.frame = CGRect(origin: indicator.frame.origin, size: CGSize(width: indicatorWidth, height: indicatorHeight))
            indicator.layer.cornerRadius = indicator.frame.height / 2
            setNeedsLayout()
        }
    }
    
    /// Vertical offset between segment and dot indicator.
    @IBInspectable
    open var indicatorOffset: CGFloat = 7 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Color of the active segment title.
    @IBInspectable
    open var titleActiveColor: UIColor = UIColor.white {
        didSet {
            for button in buttons {
                button.setTitleColor(titleActiveColor, for: .selected)
            }
        }
    }
    
    /// Color of the inactive segment title.
    @IBInspectable
    open var titleInactiveColor: UIColor = UIColor(white: 150 / 255, alpha: 1) {
        didSet {
            for button in buttons {
                button.setTitleColor(titleInactiveColor, for: UIControlState())
            }
        }
    }
    
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        titles = ["First", "Second", "Third"]
    }
    
    //MARK: - Inits
    /**
     Create an instance of DISegmentedVeiw.
     
     - parameter names: Array of the titles for segment.
     - parameter frame: Frame of the instance.
     
     - returns: Instance of the DISegmentedView.
     */
    public init(names: [String], frame: CGRect = CGRect(x: 0, y: 0, width: 44, height: 44)) {
        self.titles = names
        super.init(frame: frame)
        
        configureBaseView()
        self.configureIndicator()
        self.addButtons()
    }
    
    /**
     Create an instance of DISegmentedVeiw.
     
     - parameter frame: Frame of the instance.
     
     - returns: Instance of the DISegmentedView.
     */
    override public init(frame: CGRect) {
        self.titles = [String]()
        super.init(frame: frame)
        
        configureBaseView()
        configureIndicator()
        addButtons()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.titles = [String]()
        super.init(coder: aDecoder)
        
        configureBaseView()
        configureIndicator()
        addButtons()
    }
    
    //MARK: - Configure
    fileprivate func configureBaseView() {
        baseScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        baseScrollView.backgroundColor = .clear
        baseScrollView.showsVerticalScrollIndicator = false
        baseScrollView.showsHorizontalScrollIndicator = false
        baseScrollView.contentSize.width = CGFloat(buttons.count) * segmentLength
        
        addSubview(baseScrollView)
    }
    
    fileprivate func configureIndicator() {
        indicator.frame              = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
        indicator.clipsToBounds      = true
        indicator.backgroundColor    = tintColor
        indicator.layer.cornerRadius = indicator.frame.height / 2
        
        baseScrollView.addSubview(indicator)
    }
    
    fileprivate func addButtons() {
        for button in buttons {
            button.removeFromSuperview()
        }
        
        buttons = titles.map() { title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: UIControlState())
            button.setTitleColor(titleInactiveColor, for: UIControlState())
            button.setTitleColor(titleActiveColor, for: .selected)
            button.tintColor = UIColor.clear
            button.backgroundColor = .clear
            button.titleLabel?.font = titleFont
            button.addTarget(self, action: #selector(DISegmentedView.selectButton(_:)), for: .touchUpInside)
            
            baseScrollView.addSubview(button)
            
            return button
        }
    }
    
    open override func layoutSubviews() {
        guard !buttons.isEmpty else { return }
        
        for (index, button) in buttons.enumerated() {
            button.frame = CGRect(x: CGFloat(index) * segmentLength, y: 0, width: segmentLength, height: frame.height)
            button.titleLabel?.font = titleFont
        }
        
        buttons[selectedIndex].isSelected = true
        indicator.center = CGPoint(x: buttons[selectedIndex].center.x, y: frame.height - indicatorOffset)
        baseScrollView.contentSize.width = CGFloat(buttons.count) * segmentLength
    }
    
    //MARK: - Change state
    internal func selectButton(_ sender: UIButton) {
        setSelectedIndex(buttons.index(of: sender)!, animated: true)
    }
    
    /**
     Set the current selected segment.
     
     - parameter index:    Index of the selected index.
     - parameter animated: `true` to animate changing of the segement property.
     */
    open func setSelectedIndex(_ index: Int, animated: Bool) {
        guard selectedIndex != index && self.buttons.count > index else {
            return
        }
        
        selectedIndex = index
        self.sendActions(for: .valueChanged)

        for button in buttons {
            button.isSelected = false
        }
        self.buttons[index].isSelected = true
        UIView.animate(withDuration: animated ? 0.4 : 0, delay: 0, usingSpringWithDamping: 0.68, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.indicator.center = CGPoint(x: self.buttons[index].center.x, y: self.indicator.center.y)
            self.animateSelectionTo(index, animated: animated)
        }, completion: { (completed) in
        })
    }
    
    open func animateSelectionTo(_ index: Int, animated: Bool) {
        
        if self.titles.count > self.itemsPerPage {
            let offset = self.titles.count - self.itemsPerPage
            if index > offset {
                self.baseScrollView.setContentOffset(CGPoint(x: CGFloat(offset) * self.segmentLength, y: 0), animated: true)
            } else {
                self.baseScrollView.setContentOffset(CGPoint(x: self.indicator.frame.origin.x, y: 0), animated: true)
            }
        }
    }
}
