//
//  CustomTableViewCell.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 08/08/2023.
//

import UIKit

struct CustomTableViewCellModel {
    let title: String
    let color: UIColor
}

class CustomTableViewCell: UITableViewCell {
    
    static let cellId = "myCell"
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        overrideUserInterfaceStyle = .dark
    }
    
    func configure( _ customTableViewCellModel: CustomTableViewCellModel) {
        colorLabel.text = customTableViewCellModel.title
        self.backgroundColor = customTableViewCellModel.color
    }
}
