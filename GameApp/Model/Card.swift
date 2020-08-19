//
//  Card.swift
//  card
//
//  Created by venao8 on 18/8/20.
//  Copyright © 2020 sandhya. All rights reserved.
//

import Foundation
struct Card: Equatable {
    var cardId: Int = -1
    var value : Int = 0
    var flipped : Bool = false
    
    init(value: Int){
        self.value = value
        self.flipped = false
    }
}
