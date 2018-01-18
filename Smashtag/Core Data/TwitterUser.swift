//
//  TwitterUserModel.swift
//  Smashtag
//
//  Created by Glaphi on 13/11/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import CoreData
import UIKit

class TwitterUser: NSManagedObject {
    
    static func findOrCreateTwitterUser(matching twitterInfo: User, in context: NSManagedObjectContext) throws -> TwitterUser {
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        request.predicate = NSPredicate(format: "handle = %@", twitterInfo.screenName)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1,"TwitterUser.findOrCreateTwitterUser -- database inconsistency")
                return matches[0]
            }
        } catch { throw error }
        
        let user = TwitterUser(context: context)
        user.name = twitterInfo.name
        user.handle = twitterInfo.screenName
        return user
    }
}
