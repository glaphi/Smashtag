//
//  TwitterUser+CoreDataProperties.swift
//  
//
//  Created by Glaphi on 18/01/2018.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TwitterUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterUser> {
        return NSFetchRequest<TwitterUser>(entityName: "TwitterUser")
    }

    @NSManaged public var handle: String?
    @NSManaged public var name: String?
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for tweets
extension TwitterUser {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: TweetModel)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: TweetModel)

    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)

}
