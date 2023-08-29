//
//  CustomTableViewCell.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 08/08/2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorHeight.constant = 1/UIScreen.main.scale
    }
    
    func configure(colorName: String, BGColorName: String, isLast: Bool) {
        colorLabel.text = colorName
        myView.backgroundColor = UIColor(named: BGColorName)
        self.backgroundColor = UIColor(named: BGColorName)
        separator.isHidden = isLast
    }
}
