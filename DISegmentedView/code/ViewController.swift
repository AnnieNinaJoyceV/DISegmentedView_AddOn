//
//  ViewController.swift
//  DISegmentedView
//
//  Created by Nick on 2/2/16.
//  Copyright © 2016 spromicky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var segmentView: DISegmentedView!
    
    var codedSegmentView = DISegmentedView(names: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], frame: CGRect(x: 15, y: 75, width: UIScreen.main.bounds.size.width - 30, height: 70))

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentView.titles = ["first", "second", "third"]
        
        //coded
        codedSegmentView.itemsPerPage = 5
        codedSegmentView.selectedIndex = 0
        codedSegmentView.segmentLength = (codedSegmentView.frame.size.width) / 5.0
        codedSegmentView.indicatorWidth = ((codedSegmentView.frame.size.width) / 5.0) - 10.0
        codedSegmentView.indicatorHeight = 3.0
        codedSegmentView.tintColor = UIColor(red: 251/255, green: 215/255, blue: 251/255, alpha: 1.0)
        codedSegmentView.titleActiveColor = UIColor(red: 251/255, green: 215/255, blue: 251/255, alpha: 1.0)
        codedSegmentView.titleInactiveColor = UIColor.white.withAlphaComponent(0.75)
        codedSegmentView.titleFont = UIFont(name: "ArialRoundedMTBold", size: 18)!
        codedSegmentView.addTarget(self, action: #selector(self.updateBasedOnSegment(_:)), for: .valueChanged)
        self.view.addSubview(codedSegmentView)
    }
    
    @IBAction func changeValue(_ sender: DISegmentedView) {
        print(sender.selectedIndex)
    }
    
    func updateBasedOnSegment(_ sender: DISegmentedView) {
        print("Coded: ", sender.selectedIndex)
    }
}

