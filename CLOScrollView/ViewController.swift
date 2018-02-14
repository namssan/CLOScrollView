//
//  ViewController.swift
//  CLOScrollView
//
//  Created by Sang Nam on 14/2/18.
//  Copyright © 2018 namssanai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var swipeView : CLOScrollView = {
    
        let csv = CLOScrollView(frame: self.view.bounds)
        csv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        csv.dataSource = self
        self.view.addSubview(csv)
        
        return csv
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        _ = self.swipeView
    }
}


extension ViewController : CLOScrollViewDataSource {
    
    func numberOfItems() -> Int {
        return 10000
    }
    
    func itemView(at index: Int) -> UIView {
        
        let view = UIView(frame: self.swipeView.bounds)
        let color = UIColor.generateRandomColor()
        view.backgroundColor = color
        let lbl = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 30))
        lbl.font = UIFont.systemFont(ofSize: 55.0, weight: .bold)
        lbl.textColor = .white
        lbl.text = String(format: "%03d",index + 1)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lbl)
        let constX = NSLayoutConstraint(item: lbl, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let constY = NSLayoutConstraint(item: lbl, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let constW = NSLayoutConstraint(item: lbl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150.0)
        let constH = NSLayoutConstraint(item: lbl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70.0)
        view.addConstraints([constX,constY,constW,constH])
        
        return view
    }
}
