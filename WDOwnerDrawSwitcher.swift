//
//  WDOwnerDrawSwitcher.swift
//  xmksBg
//
//  Created by apple on 2017/1/9.
//  Copyright © 2017年 zhoutai. All rights reserved.
//  fillWithBlendMode(.Normal, alpha: 0.5) //填充模式为半透明

import UIKit
import SnapKit

enum WDOwnerDrawSwitcherType {
    case singleness
    case Multipiece
}

protocol WDOwnerDrawSwitcherDelegate {
    func WDSwitcherValueChanged(switcher:WDOwnerDrawSwitcher, type:WDOwnerDrawSwitcherType)
}

class WDOwnerDrawSwitcher: UIView {

    var w:CGFloat?
    var leftLabel:UILabel?
    var rightLabel:UILabel?
    var centerTmpX:Constraint? = nil
    var delegate:WDOwnerDrawSwitcherDelegate?
    var controlSwitcher:String?{
        didSet{
            if controlSwitcher == "0" {//单件
                let left:UITapGestureRecognizer = UITapGestureRecognizer.init()
                leftDidClick(tap: left)
            }else{
                let right:UITapGestureRecognizer = UITapGestureRecognizer.init()
                rightDidClick(tap: right)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.w = frame.size.width
        setSwitcherView()
        self.isUserInteractionEnabled = true
    }
    
    func setSwitcherView() {
        self.addSubview(switcherBg)
        switcherBg.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        let left:UILabel = UILabel.init()
        left.translatesAutoresizingMaskIntoConstraints = false
        self.leftLabel = left
        switcherBg.addSubview(left)
        left.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalTo(self.w!/2.0)
            make.height.equalTo(switcherBg)
            make.top.equalTo(0)
        }
        left.tag = 10000
        let leftTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(WDOwnerDrawSwitcher.leftDidClick(tap:)))
        left.isUserInteractionEnabled = true
        left.addGestureRecognizer(leftTap)
        left.text = "单件"
        left.textAlignment = NSTextAlignment.center
        left.font = UIFont.systemFont(ofSize: 15)
        
        let right:UILabel = UILabel.init()
        right.translatesAutoresizingMaskIntoConstraints = false
        right.isUserInteractionEnabled = true
        self.rightLabel = right
        switcherBg.addSubview(right)
        right.snp.makeConstraints { (make) in
            make.left.equalTo(left.snp.right).offset(0)
            make.width.equalTo(self.w!/2.0)
            make.height.equalTo(switcherBg)
            make.top.equalTo(0)
        }
        right.tag = 10001
        let rightTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(WDOwnerDrawSwitcher.rightDidClick(tap:)))
        right.addGestureRecognizer(rightTap)
        right.text = "批量"
        right.textAlignment = NSTextAlignment.center
        right.font = UIFont.systemFont(ofSize: 15)
        switcherBg.addSubview(switcherItem)
        switcherItem.snp.makeConstraints { (make) in
            self.centerTmpX = make.centerX.equalTo(left).constraint
            make.width.equalTo(left)
            make.height.equalTo(left)
            make.top.equalTo(left)
        }
        switcherItem.setTitle("单件", for: UIControlState.normal)
    }
    
    func leftDidClick(tap:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.25, animations: {
            self.centerTmpX?.update(offset: 0)
            self.layoutIfNeeded()
        }) { (finished) in
            self.switcherItem.setTitle("单件", for: UIControlState.normal)
            self.delegate?.WDSwitcherValueChanged(switcher: self, type:WDOwnerDrawSwitcherType.singleness)
        }
    }
    
    func rightDidClick(tap:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.25, animations: {
            self.centerTmpX?.update(offset: self.w!/2.0)
            self.layoutIfNeeded()
        }) { (finished) in
            self.switcherItem.setTitle("批量", for: UIControlState.normal)
            self.delegate?.WDSwitcherValueChanged(switcher: self, type: WDOwnerDrawSwitcherType.Multipiece)
        }
    }
    
    private lazy var switcherBg:UIView = {
        let bg = UIView.init()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.isUserInteractionEnabled = true
        bg.backgroundColor = WDSwitcherBg
        bg.layer.cornerRadius = 12
        return bg
    }()
    
    private lazy var switcherItem:UIButton = {
        let item:UIButton = UIButton.init()
        item.setTitleColor(UIColor.white, for: UIControlState.normal)
        item.translatesAutoresizingMaskIntoConstraints = false
        item.backgroundColor = WDThemeColor
        item.layer.cornerRadius = 12
        item.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return item
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
