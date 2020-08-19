//
//  CardViewModel.swift
//  card
//
//  Created by venao8 on 18/8/20.
//  Copyright © 2020 sandhya. All rights reserved.
//

import Foundation
class GameCardViewModel {
    //Card Cards steps
    var record = 0
    
    //Current Game Variables
    var randomArray = [Int]()
    var currentActiveDeck = [Card]()
    var currentActiveChosenCards = [Card]()
    var currentActiveChosenCardsIdx = [IndexPath]()
    var flippedCards = [IndexPath]()
    var currentScore = 0
    
    func createDeckOfCards() {
        self.resetAll()
        randomArray = getRandomArray()
        var totalCards = Constants.kMaxPair * 2
        var cardCounter = 1
        
        while(totalCards>0){
            var newCard1 = Card(value: 0)
            newCard1.cardId = cardCounter
            newCard1.value = randomArray[cardCounter - 1]
            self.currentActiveDeck.append(newCard1)
            cardCounter+=1
            totalCards-=1
        }
        self.currentActiveDeck.shuffle()
    }
    func resetAll(){
        currentScore = 0
        currentActiveDeck.removeAll()
        currentActiveChosenCards.removeAll()
        currentActiveChosenCardsIdx.removeAll()
        flippedCards.removeAll()
        randomArray.removeAll()
    }
    func selectCard(card: Card, indexPath: IndexPath) {
        self.record+=1
        if self.currentActiveChosenCards.count <= 1 {
            let chosenCard = card
            self.currentActiveChosenCards.append(chosenCard)
            self.currentActiveChosenCardsIdx.append(indexPath)
            self.flippedCards.append(indexPath)
            if self.currentActiveChosenCards.count == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // your function here
                    self.checkCards()
                }
            }
        }
    }
    func getRandomArray() -> [Int] {
        let val = Array(1..<100)
        let result: [Int] = Array(0..<Constants.kMaxPair).map({_ in (val.randomElement() ?? 0)})
        let randomIntArr = result + result
        return randomIntArr
    }
    // Card Result :
    // 0 - First Card, Do Nothing, reload
    // 1 - Second Card, Matched, reload
    // 2 - Second Card, MisMatch, reload
    // 3 - Last Pair, Game End
    
    private func checkCards() {
        let isMatched = checkIfMatch()
        if isMatched == true {
            self.currentActiveChosenCards.removeAll()
            self.currentActiveChosenCardsIdx.removeAll()
            self.currentScore += 1
            if self.currentScore == Constants.kMaxPair {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kGameEndNotificationName), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kMatchNotificationName), object: nil)
            }
        } else {
            let firstCard = self.currentActiveChosenCardsIdx[0]
            let secondCard = self.currentActiveChosenCardsIdx[1]
            self.flippedCards = self.flippedCards.filter({$0 != firstCard})
            self.flippedCards = self.flippedCards.filter({$0 != secondCard})
            self.currentActiveChosenCards.removeAll()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kMisMatchNotificationName), object: nil)
        }
    }
    func checkIfMatch() -> Bool {
        let firstCard = self.currentActiveChosenCards[0]
        let secondCard = self.currentActiveChosenCards[1]
        if firstCard.value == secondCard.value {
            return true
        }
        return false
    }
}
