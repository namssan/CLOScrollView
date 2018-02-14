//
//  CLOScrollView.swift
//  CLOScrollView
//
//  Created by Sang Nam on 14/2/18.
//  Copyright © 2018 namssanai. All rights reserved.
//

import UIKit

protocol CLOScrollViewDataSource : class {
    func numberOfItems() -> Int
    func itemView(at index : Int) -> UIView
}

class CLOScrollView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var containers : [UIView] = []
    private var numberOfItems : Int = 0
    var curItemIndex : Int = 0
    
    var scrollView : UIScrollView?
    
    weak var dataSource : CLOScrollViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        print("layout sub views")
        super.layoutSubviews()
        self.setup()
    }
    
    func setupScrollView() {
        
        guard scrollView == nil else { return }
        scrollView = UIScrollView(frame: self.bounds)
        scrollView?.autoresizesSubviews = true
        scrollView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        scrollView?.isPagingEnabled = true
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.delegate = self
        scrollView?.backgroundColor = .clear
        self.addSubview(scrollView!)
    }
    
    func removeScrollView() {
        
        guard scrollView != nil else { return }
        scrollView?.removeFromSuperview()
        scrollView = nil
    }
    
    func setup() {
        
        self.removeScrollView()
        self.setupScrollView()
        
        self.backgroundColor = .clear
        let W = self.frame.size.width
        let H = self.frame.size.height
        
        if let no = dataSource?.numberOfItems() {
            numberOfItems = no
        }
        
        // initialize containers
        for idx in 0..<3 {
            let rect = CGRect(x: 0.0, y: H * CGFloat(idx), width: W, height: H)
            let view = UIView(frame: rect)
            view.backgroundColor = .clear
            scrollView?.addSubview(view)
            self.containers.append(view)
        }
        
        let numberOfLoads = min(numberOfItems,3)
        scrollView?.contentSize = CGSize(width: W, height: H * CGFloat(numberOfItems))
        
        for idx in 0..<numberOfLoads {
            let container = self.containers[idx]
            container.tag = idx
            if let sb = self.dataSource?.itemView(at: idx) {
                container.addSubview(sb)
            }
        }
    }
    
    private func chooseVictimContainer(idx : Int) -> UIView {
        
        let prevIdx = idx - 1
        let nextIdx = idx + 1
        var container : UIView?
        
        for con in self.containers {
            if(con.tag != prevIdx && con.tag != idx && con.tag != nextIdx) {
                container = con
                break
            }
        }
        
        return container!
    }
    
    private func loadItems(at idx : Int) {
        
        let prevIdx = idx - 1
        let nextIdx = idx + 1
        
        let H = self.frame.size.height
        
        if prevIdx >= 0 {
            
            var recycleContainer : UIView?
            for container in self.containers {
                if(container.tag == prevIdx) {
                    recycleContainer = container
                    break
                }
            }
            if recycleContainer == nil {
                let victim = self.chooseVictimContainer(idx: idx)
                victim.tag = prevIdx
                victim.frame.origin.y = CGFloat(prevIdx) * H
                
                if let sb = self.dataSource?.itemView(at: prevIdx) {
                    victim.addSubview(sb)
                }
            }
        }
        
        
        if nextIdx < numberOfItems {
            var recycleContainer : UIView?
            for container in self.containers {
                if(container.tag == nextIdx) {
                    recycleContainer = container
                    break
                }
            }
            if recycleContainer == nil {
                let victim = self.chooseVictimContainer(idx: idx)
                victim.tag = nextIdx
                victim.frame.origin.y = CGFloat(nextIdx) * H
                
                if let sb = self.dataSource?.itemView(at: nextIdx) {
                    victim.addSubview(sb)
                }
            }
        }
        
    }
    
}


extension CLOScrollView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.updateCurrentItemIndex()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("decelerating did end")
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("animation did end")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!decelerate) {
//            print("dragging did end withouht delerating")
        }
    }
    
    func updateCurrentItemIndex() {
        
        let offY = scrollView!.contentOffset.y
        let H = self.frame.size.height
        let idx = Int(offY / H)

        if(curItemIndex != idx) {
            curItemIndex = idx
            print("Current Item Index Changed: \(idx)")
            self.loadItems(at: idx)
        }
    }
}
