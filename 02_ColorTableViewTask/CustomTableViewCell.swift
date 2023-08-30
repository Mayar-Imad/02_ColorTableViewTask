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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(colorName: String) {
        colorLabel.text = colorName
        myView.backgroundColor = UIColor(named: colorName)
        self.backgroundColor = UIColor(named: colorName)
    }
}
