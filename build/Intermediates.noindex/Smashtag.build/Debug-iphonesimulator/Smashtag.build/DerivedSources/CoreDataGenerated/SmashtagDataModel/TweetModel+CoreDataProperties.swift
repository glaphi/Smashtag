//
//  TweetModel+CoreDataProperties.swift
//  
//
//  Created by Glaphi on 18/01/2018.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TweetModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetModel> {
        return NSFetchRequest<TweetModel>(entityName: "TweetModel")
    }

    @NSManaged public var created: Date?
    @NSManaged public var identifier: String?
    @NSManaged public var text: String?
    @NSManaged public var tweeter: TwitterUser?

}
