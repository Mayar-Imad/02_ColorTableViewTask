//
//  Constants.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 30/08/2023.
//

import Foundation

struct Constants {
    struct Text  {
        static let initialDescription = "Description\n\nColors are visual sensations produced by different wavelengths of light. They evoke emotions, convey meaning, and play a vital role in design and communication."
        static let titles: [String] = ["Deep Teal", "Catalina Blue", "Dark Indigo", "Ripe Plum", "Mulberry Wood", "Kenyan Copper", "Chestnut", "Antique Bronze"]
        static let desriptions: [String] = ["Deep Teal description", "Catalina Blue description", "Dark Indigo description", "Ripe Plum description", "Mulberry Wood description", "Kenyan Copper description", "Chestnut description", "Antique Bronze description"]
    }
    
    struct ColorName {
        static let colorsName: [String] = ["DeepTeal", "CatalinaBlue", "DarkIndigo", "RipePlum", "MulberryWood", "KenyanCopper", "Chestnut", "AntiqueBronze"]
    }
    
    static let colorsIdKey = "colorsId"
    static let customTableViewCellNibName = "CustomTableViewCell"
    static let NewColorVCIdentifier = "NewColor"
}
