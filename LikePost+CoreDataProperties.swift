//
//  LikePost+CoreDataProperties.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.06.2024.
//
//

import Foundation
import CoreData


extension LikePost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikePost> {
        return NSFetchRequest<LikePost>(entityName: "LikePost")
    }

    @NSManaged public var author: String?
    @NSManaged public var postDescription: String?
    @NSManaged public var image: String?
    @NSManaged public var likes: Int16
    @NSManaged public var views: Int16

}

extension LikePost : Identifiable {

}
