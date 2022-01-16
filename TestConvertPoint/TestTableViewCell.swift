//
//  TestTableViewCell.swift
//  TestConvertPoint
//
//  Created by Khanh Pham on 1/12/22.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topStatusLabel: UILabel!
    @IBOutlet weak var bottomStatusLabel: UILabel!
    
    func configure(topTitle: String, title: String, vc: ViewController) {
        topTitleLabel.text = topTitle
        titleLabel.text = title
        vc.delegate = self
    }
}

extension TestTableViewCell: ViewControllerDelegate {
    func convertPos(mainView: UIView, scrollView: UIScrollView, atIndex index: Int) {
        
    }
    
    func changeStatus(text: String) {
        topStatusLabel.text = text
        bottomStatusLabel.text = text
    }
}
