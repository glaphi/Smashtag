//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Glaphi on 04/11/2017.
//  Copyright © 2017 glaphi. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var twitterProfileImage: UIImageView!
    @IBOutlet weak var twitterUsernameLabel: UILabel!
    @IBOutlet weak var twitterTweetText: UILabel!
    @IBOutlet weak var twitterTweetCreated: UILabel!
    
    var tweet: Tweet? { didSet { updateUI() } }
    
    struct mentionsColors { // valid for any instance of Tweet Cell
         static let hashtags = UIColor.cyan
         static let urls = UIColor.blue
         static let userMentions = UIColor.red
    }
    
    // Function to set the text for tweet and color mensions
    private func setAttributedTweet(_ tweetData: Tweet?) -> NSMutableAttributedString {
        if tweetData != nil {
            var text: String = tweetData!.text
            for _ in tweetData!.media { text += "  📷"}
            let attributedTweet = NSMutableAttributedString(string: text)
            attributedTweet.setMentionsColor(tweetData!.hashtags, color: mentionsColors.hashtags)
            attributedTweet.setMentionsColor(tweetData!.urls, color: mentionsColors.urls)
            attributedTweet.setMentionsColor(tweetData!.userMentions, color: mentionsColors.userMentions)
            return attributedTweet
        } else { return NSMutableAttributedString(string: "") }
    }
    
    private func updateUI() {
        // twitterTweetText?.text = tweet?.text
        twitterTweetText?.attributedText = setAttributedTweet(tweet)
        twitterUsernameLabel?.text = tweet?.user.description
        
        let tweetIdBeforeNetworkCall = tweet?.identifier
        
        if let profileImageUrl = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: profileImageUrl) {
                    DispatchQueue.main.async {
                        self?.twitterProfileImage?.image = UIImage(data: imageData)
                        /// Check if this block is being cold on the same cell. (Its possible
                        /// that the cell is re-used for a different row than what it was
                        /// at the beginning of the network call)
                        if self?.tweet?.identifier == tweetIdBeforeNetworkCall {
                            self?.twitterProfileImage?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        } else { twitterProfileImage?.image = nil }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            twitterTweetCreated?.text = formatter.string(from: created)
        } else {
            twitterTweetCreated?.text = nil
        }
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}

// MARK: Extension for Attributed Tweet to set the prefered colors for mensions

private extension NSMutableAttributedString {
    func setMentionsColor(_ mentions: [Mention], color: UIColor) {
        for mention in mentions {
            addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: mention.nsrange)
            // NSAttributedStringKey.foregroundColor : the value of this attribute is a UIColor object.
            // Use this attribute to specify the color of the text during rendering.
            // If you do not specify this attribute, the text is rendered in black.
        }
    }
}
