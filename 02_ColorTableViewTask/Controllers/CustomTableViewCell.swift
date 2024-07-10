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
    let imageName: String
}

class CustomTableViewCell: UITableViewCell {
    
    static let cellId = "myCell"
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        overrideUserInterfaceStyle = .dark
    }
    
    func configure( _ customTableViewCellModel: CustomTableViewCellModel) {
        colorLabel.text = customTableViewCellModel.title
        self.backgroundColor = customTableViewCellModel.color
        if (customTableViewCellModel.imageName == "circle" || customTableViewCellModel.imageName == "checkmark.circle.fill") {
            cellImage.image = UIImage(systemName: customTableViewCellModel.imageName)
            cellImage.tintColor = .white
            cellImage.isHidden = false
        } else {
            cellImage.isHidden = true
        }
        self.layoutIfNeeded()
    }
}
