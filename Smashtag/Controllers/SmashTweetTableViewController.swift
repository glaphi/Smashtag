//
//  SmashtagDataModelTableViewController.swift
//  Smashtag
//
//  Created by Glaphi on 13/11/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import CoreData
import UIKit

class SmashTweetTableViewController: TweetTableViewController {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private func updateDatabase(with tweets: [Tweet]) {
        print("Started Loading Database")
        container?.performBackgroundTask { [weak self] context in // context for the other queue
            for twitterInfo in tweets {
                // if cannot create the tweet just don't update it
                // underbar _ means ignore the return value
                _ = try? TweetModel.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("Done Loading Database")
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics(){
        if let context = container?.viewContext { // main view context
            context.perform { // core data safety. we need to be on the main thread for the context
               // if Thread.isMainThread { print("on main thread")} else {print("off main thread")}
            let request: NSFetchRequest<TweetModel> = TweetModel.fetchRequest()
            if let tweetCount = (try? context.fetch(request))?.count {
                print("\(tweetCount) tweets")
            }
            if let tweeterUserCount = try? context.count(for: TwitterUser.fetchRequest()) {
                print("\(tweeterUserCount) Twitter users")
            }
            }
        }
    }
    
    override func insertTweets(_ newTweets: [Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
    }

}



