//
//  ColorDataSource+CoreDataProperties.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 20/09/2023.
//
//

import Foundation
import CoreData


extension ColorDataSource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorDataSource> {
        return NSFetchRequest<ColorDataSource>(entityName: "ColorDataSource")
    }

    @NSManaged public var title: String?
    @NSManaged public var color: String?
    @NSManaged public var colorDescription: String?
    @NSManaged public var position: Int32

}

extension ColorDataSource : Identifiable {

}
