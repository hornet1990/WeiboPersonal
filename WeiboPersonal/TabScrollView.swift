//
//  TabScrollView.swift
//  WeiboPersonal
//
//  Created by Andrew on 2017/4/21.
//
//

import UIKit

@objc protocol TabScrollViewDelegate: NSObjectProtocol {
    @objc func scrollMainScrollViewToX(_ x: CGFloat) -> Void
}

let BtnHeight = 38
let HTHeight = 2

class TabScrollView: UIView {

    weak var delegate: TabScrollViewDelegate?
    var topView: UIView?
    var htView: UIView?
    var width: CGFloat?
    var height: CGFloat?
    var selectBtn: UIButton?
    var btnWidth: CGFloat?
    lazy var btnNameArray: [String] = {
        var array = [String]()
        return array
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, nameArray: [String]) {
        super.init(frame: frame)
        self.frame = frame;
        backgroundColor = .clear
        width = frame.size.width
        height = frame.size.height
        btnNameArray.append(contentsOf: nameArray)
        
        let buttonHeight = 43
        var x: CGFloat = 0.0
        topView = UIView(frame: CGRect(x: 0, y: 0, width: width!, height: CGFloat(buttonHeight + HTHeight)))
        btnWidth = width!/CGFloat(nameArray.count)
        for i in 0..<nameArray.count {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: x, y: 0, width: btnWidth!, height: CGFloat(buttonHeight))
            button.setTitle(nameArray[i], for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            button.setTitleColor(UIColorFromRGB(0x72706e), for: .normal)
            button.setTitleColor(UIColorFromRGB(0xff7788), for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            button.tag = 1000 + i
            topView?.addSubview(button)
            x += btnWidth!
            if i == 0 {
                button.isSelected = true
                selectBtn = button
            }
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: buttonHeight + 1, width: Int(ScreenWidth), height: 1))
        lineView.backgroundColor = UIColorFromRGB(0xf5f3f0)
        topView?.addSubview(lineView)
        
        htView = UIView(frame: CGRect(x: 0, y: CGFloat(buttonHeight), width: btnWidth!, height: CGFloat(HTHeight)))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: HTHeight))
        view.backgroundColor = UIColorFromRGB(0xff7788)
        htView?.addSubview(view)
        view.center = CGPoint(x: (htView?.bounds.size.width)!/2.0, y: (htView?.bounds.size.height)!/2.0)
        topView?.addSubview(htView!)
        self.addSubview(topView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonAction(_ button: UIButton) -> Void {
        moveHTViewToX(button.frame.origin.x, button: button)
        moveScrollViewToX(button.frame.origin.x/btnWidth!*ScreenWidth, button: button)
    }
    
    func moveHTViewToX(_ x: CGFloat, button: UIButton) -> Void {
        selectBtn?.isSelected = false
        button.isSelected = true
        selectBtn = button
    }
    
    func moveScrollViewToX(_ x: CGFloat, button: UIButton) -> Void {
        if self.delegate != nil && (self.delegate?.responds(to: #selector(TabScrollViewDelegate.scrollMainScrollViewToX(_:))))! {
            self.delegate?.scrollMainScrollViewToX(CGFloat(button.tag - 1000) * ScreenWidth)
        }
    }
    
    func changeOrgAndStateWithX(_ x: CGFloat) -> Void {
        let index = Int(x/ScreenWidth)
        let button = self.viewWithTag(1000 + index) as! UIButton
        UIView.animate(withDuration: 0.2) {
            self.htView?.frame.origin.x = button.frame.origin.x
        }
        selectBtn?.isSelected = false
        button.isSelected = true
        selectBtn = button
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
