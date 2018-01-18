//
//  TweetModel.swift
//  Smashtag
//
//  Created by Glaphi on 13/11/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import CoreData
import UIKit

class TweetModel: NSManagedObject {
    
    static func findOrCreateTweet(matching twitterInfo: Tweet, in context: NSManagedObjectContext) throws -> TweetModel {
        let request: NSFetchRequest<TweetModel> = TweetModel.fetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", twitterInfo.identifier)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1,"TweetModel.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch { throw error }
        
        let tweet = TweetModel(context: context)
        tweet.identifier = twitterInfo.identifier
        tweet.created = twitterInfo.created
        tweet.text = twitterInfo.text
        tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
        return tweet
    }
    
}
