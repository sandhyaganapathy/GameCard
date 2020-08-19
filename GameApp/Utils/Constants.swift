//
//  Constants.swift
//  card
//
//  Created by venao8 on 18/8/20.
//  Copyright © 2020 sandhya. All rights reserved.
//

import Foundation
struct Constants {
    //Notifications
    static let kMisMatchNotificationName = "MisMatchedNotification"
    static let kMatchNotificationName = "MatchedNotification"
    static let kGameEndNotificationName = "GameEndNotification"
    static let kMaxPair = 6
}
enum GameState: NSInteger {
    case Playing
    case NotPlaying
    case GameEnd
}
extension Array
{
    mutating func shuffle()
    {
        for _ in 0..<8
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
