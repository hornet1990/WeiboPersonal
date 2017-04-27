//
//  ContentViewController.swift
//  WeiboPersonal
//
//  Created by Andrew on 2017/4/21.
//
//

import UIKit

@objc protocol ContentVCScrollDelegate: NSObjectProtocol {
    @objc func contentVCDidScrollContentOffset(_ offsetY: CGFloat)
}

class ContentViewController: UIViewController {
    
    weak var delegate: ContentVCScrollDelegate?
    lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
        tableView.contentInset = UIEdgeInsetsMake(285, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColorFromRGB(0xf5f3f0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(self.listTableView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContentViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "testCell")
        cell.textLabel?.text = "test====\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if self.delegate != nil && (self.delegate?.responds(to: #selector(ContentVCScrollDelegate.contentVCDidScrollContentOffset(_:))))! {
            self.delegate?.contentVCDidScrollContentOffset(offsetY)
        }
    }
}
