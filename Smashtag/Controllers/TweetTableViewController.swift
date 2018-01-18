//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Glaphi on 01/11/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var SearchTextField: UITextField! { didSet { SearchTextField.delegate = self } }
    @IBAction func refresh(_ sender: UIRefreshControl) { searchForTweets() }
    
    var searchText: String? {
        didSet {
            SearchTextField?.text = searchText
            SearchTextField?.resignFirstResponder() // hides the keyboard, very important!
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    // Mark: Model
    private var tweets = [Array<Tweet>]() {
        didSet {
            print("Got tweets")
        }
    }
    
    private var lastTwitterRequest: Request?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == SearchTextField { searchText = SearchTextField.text }
        return true
    }
    
    private func twitterRequest() -> Request? {
        if let query = searchText, !query.isEmpty {
            return Request (search: "\(query) -filter:safe -filter:retweets", count: 100)
        }
        return nil
    }
    
    internal func insertTweets(_ newTweets: [Tweet]) {
        self.tweets.insert(newTweets, at:0)
        self.tableView.insertSections([0], with: .fade)
    }
    
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets{ [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.insertTweets(newTweets)
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else { self.refreshControl?.endRefreshing() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // estimated height is set to the height of the prototype cell
        tableView.estimatedRowHeight = tableView.rowHeight
        // setting the row height of each cell to git the text of tweet
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return tweets.count }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweet: Tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count-section)"
    }
}
