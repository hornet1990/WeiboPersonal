//
//  ViewController.swift
//  WeiboPersonal
//
//  Created by Andrew on 2017/4/21.
//
//

import UIKit

let HeaderHeight: CGFloat = 240
let TopScrollHeight: CGFloat = 45

class ViewController: UIViewController {

    lazy var viewControllerArray: [ContentViewController] = {
        var array = [ContentViewController]()
        return array
    }()
    
    lazy var lineView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 63, width: ScreenWidth, height: 1))
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 32, width: ScreenWidth, height: 20))
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .white
        label.text = "WeiboPersonal"
        label.textAlignment = .center
        return label
    }()
    
    lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 64))
        view.backgroundColor = .clear
        view.addSubview(self.titleLabel)
        view.addSubview(self.lineView)
        return view
    }()
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: HeaderHeight))
        view.backgroundColor = .red
        return view
    }()
    
    lazy var topScrollView: TabScrollView = {
        let scrollView = TabScrollView(frame: CGRect(x: 0, y: HeaderHeight, width: ScreenWidth, height: TopScrollHeight), nameArray: ["tab0","tab1","tab2","tab3"])
        scrollView.delegate = self
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var bottomScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: ScreenWidth * 4, height: ScreenHeight)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        for i in 0...3 {
            let contentVC = ContentViewController()
            contentVC.view.frame = CGRect(x: ScreenWidth * CGFloat(i), y: 0, width: ScreenWidth, height: ScreenHeight)
            if i == 0 {
                contentVC.delegate = self
            }
            self.viewControllerArray.append(contentVC)
            self.addChildViewController(contentVC)
            scrollView.addSubview(contentVC.view)
        }
        return scrollView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(bottomScrollView)
        view.addSubview(headerView)
        view.addSubview(topScrollView)
        view.addSubview(topView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: TabScrollViewDelegate,ContentVCScrollDelegate,UIScrollViewDelegate {
    func scrollMainScrollViewToX(_ x: CGFloat) {
        setDelegateWithOffset(x)
        UIView.animate(withDuration: 0.2) {
            self.bottomScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bottomScrollView {
            let offsetX = scrollView.contentOffset.x
            setDelegateWithOffset(offsetX)
            let width = Int(offsetX)
            let allWidth = Int(ScreenWidth)
            if width % allWidth == 0 {
                topScrollView.changeOrgAndStateWithX(offsetX)
            }
        }
    }
    
    func contentVCDidScrollContentOffset(_ offsetY: CGFloat) {
        for contentVC in self.viewControllerArray {
            let height: CGFloat = -45 - 64
            if offsetY <= height {
                contentVC.listTableView.contentOffset = CGPoint(x: 0, y: offsetY)
            } else {
                let positionY = contentVC.listTableView.contentOffset.y
                if positionY < height {
                    contentVC.listTableView.contentOffset = CGPoint(x: 0, y: height)
                }
            }
        }
        
        let y = offsetY + HeaderHeight + TopScrollHeight
        
        let alpha = Float(y/64.0)
        topView.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: alpha)
        lineView.backgroundColor = UIColor(colorLiteralRed: 237.0/255.0, green: 231.0/255.0, blue: 228.0/255.0, alpha: alpha)
        if y > 34 {
            UIView.animate(withDuration: 0.4, animations: {
                self.titleLabel.textColor = UIColorFromRGB(0xff7788)
                UIApplication.shared.setStatusBarStyle(.default, animated: true)
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.titleLabel.textColor = .white
                UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
            })
        }
        
        if y >= HeaderHeight - 64 {
            headerView.frame = CGRect(x: 0, y: -HeaderHeight + 64, width: ScreenWidth, height: HeaderHeight)
            topScrollView.frame = CGRect(x: 0, y: 64, width: ScreenWidth, height: 45)
        } else if y <= 0 {
            headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: -y + HeaderHeight)
            topScrollView.frame = CGRect(x: 0, y: -y + HeaderHeight, width: ScreenWidth, height: 45)
        } else {
            headerView.frame = CGRect(x: 0, y: -y, width: ScreenWidth, height: HeaderHeight)
            topScrollView.frame = CGRect(x: 0, y: -y + HeaderHeight, width: ScreenWidth, height: 45)
        }
    }
    
    func setDelegateWithOffset(_ offsetX: CGFloat) -> Void {
        for contentVC in self.viewControllerArray {
            contentVC.delegate = nil
        }
        let index = Int(offsetX)/Int(ScreenWidth)
        if index < viewControllerArray.count {
            let contentVC = viewControllerArray[index]
            contentVC.delegate = self
        }
    }
}

