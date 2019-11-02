//
//  TabBarView.swift
//  LitNet
//
//  Created by Igor Karyi on 30.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import UIKit
import Rswift

// MARK: - TabBarLabel

private class TabBarLabel: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.01176470588, green: 0.01176470588, blue: 0.01176470588, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let highlightedLine: UIView = {
        let view = UIView()
        view.backgroundColor = TabBarView.Config.bottomLineColor
        view.alpha = 0
        return view
    }()
    
    private(set) var isSelected: Bool = false
    
    // Constructors
    
    init(with text: String) {
        super.init(frame: .zero)
        
        self.addSubview(self.label)
        self.addSubview(self.highlightedLine)

        self.label.text = text
        
        self.isUserInteractionEnabled = true
        self.set(isSelected: false, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    // Layout
    
    override var intrinsicContentSize: CGSize {
        return self.label.intrinsicContentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // configure label
        let labelSize = self.label.sizeThatFits(self.bounds.size)
        self.label.frame = CGRect(
            x: 0,
            y: labelSize.height,
            width: self.bounds.width,
            height: labelSize.height
        )
        
        // configure bottom line
        self.highlightedLine.frame = CGRect(
            x: 0,
            y: self.bounds.height - TabBarView.Config.bottomLineHeight,
            width: self.bounds.width,
            height: TabBarView.Config.bottomLineHeight
        )

    }
    
    func set(isSelected: Bool, animated: Bool) {
        self.isSelected = isSelected
        
        if animated {
            let anim = CATransition()
            anim.duration = CATransaction.animationDuration()
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            anim.type = .fade
            anim.isRemovedOnCompletion = true
            self.label.layer.add(anim, forKey: "fade")
        }
        
        let font = self.isSelected
            ? R.font.latoBold(size: 16)
            : R.font.latoLight(size: 16)
        
        let color = self.isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.label.textColor = color
        self.label.font = font
    }
    
    // Highlighting control
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.update(isHighlighted: true, animated: true)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.update(isHighlighted: false, animated: true)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.update(isHighlighted: false, animated: true)
    }
    
    private func update(isHighlighted: Bool, animated: Bool) {
        let alpha: CGFloat = isHighlighted ? 0.35 : 0

        let animBlock: () -> Void = { [unowned self] in
            self.highlightedLine.alpha = alpha
        }
        
        guard animated else {
            animBlock()
            return
        }
        
        let duration: TimeInterval = isHighlighted
            ? CATransaction.animationDuration() / 1.5
            : CATransaction.animationDuration()

        UIView.performAnimation(duration: duration, block: animBlock)
    }
    
}

// MARK: - TabBarView

@objc protocol TabBarViewDelegate: class {
    func tabBarView(_ tabbBarView: TabBarView, didSelect index: Int)
}

extension TabBarViewDelegate {
    func tabBarView(_ tabbBarView: TabBarView, didSelect index: Int) { }
}

//@IBDesignable
class TabBarView: UIControl {
    fileprivate enum Config {
        static let height = CGFloat(34)
        
        static let bottomLineHeight = CGFloat(4)
        static let bottomLineColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    struct Item {
        var title: String
    }
    
    @IBOutlet weak var delegate: TabBarViewDelegate?
    
    // MARK: - Items
    
    fileprivate var labels = [TabBarLabel]() {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            self.labels.forEach { self.insertSubview($0, at: 0) }
        }
    }
    
    fileprivate var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = Config.bottomLineColor
        return view
    }()
    
    // MARK: - Public properties
    
    override var intrinsicContentSize: CGSize {
        if let parent = self.superview {
            return CGSize(width: parent.bounds.width, height: Config.height)
        }
        
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: Config.height)
    }
    
    fileprivate(set) var selectedIndex = 0
    
    // MARK: - Constructors & destructor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        self.addSubview(self.bottomLine)
    }
    
    // MARK: - Public setters
    
    func set(items: [Item]) {
        if items.isEmpty {
            self.labels = []
            self.selectedIndex = -1
            return
        }
        
        // create labels
        self.labels = items.map {
            let label = TabBarLabel(with: $0.title)
            let tap = UITapGestureRecognizer(target: self, action: #selector(tabItemTap(_:)))
            label.addGestureRecognizer(tap)
            return label
        }
        
        self.selectedIndex = 0
        self.labels[self.selectedIndex].set(isSelected: true, animated: false)
        
        
        // update layout
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func set(index: Int, animated: Bool) {
        assert(index >= 0)
        
        self.labels[index].set(isSelected: true, animated: animated)
        self.labels[self.selectedIndex].set(isSelected: false, animated: animated)
        
        self.selectedIndex = index
        
        if animated {
            UIView.performAnimation(duration: CATransaction.animationDuration(), block: {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemSize = CGSize(
            width: self.itemWidth(count: self.labels.count),
            height: self.bounds.height
        )
        
        // update items position
        for (idx, label) in self.labels.enumerated() {
            let frame = CGRect(
                x: CGFloat(idx) * itemSize.width,
                y: 0,
                width: itemSize.width,
                height: itemSize.height
            )
            
            label.frame = frame
        }
        
        // update bottom line
        self.bottomLine.frame = CGRect(
            x: itemSize.width * CGFloat(self.selectedIndex),
            y: itemSize.height - Config.bottomLineHeight,
            width: itemSize.width,
            height: Config.bottomLineHeight
        )
    }
    
}

private extension TabBarView {

    func itemWidth(count: Int) -> CGFloat {
        return floor(self.bounds.width / CGFloat(count))
    }
    
    @objc func tabItemTap(_ sender: UITapGestureRecognizer) {
        let label = sender.view as! TabBarLabel
        let idx = self.labels.firstIndex(of: label)!
        
        if idx != self.selectedIndex {
            self.set(index: idx, animated: true)
            
            self.delegate?.tabBarView(self, didSelect: idx)
        }
    }
    
}
