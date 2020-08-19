//
//  GameAppTests.swift
//  GameAppTests
//
//  Created by venao8 on 18/8/20.
//  Copyright © 2020 sandhya. All rights reserved.
//

import XCTest
@testable import GameApp

class GameAppTests: XCTestCase {
    let viewModel = GameCardViewModel()
    func testCreateDeckOfCards() {
        self.viewModel.createDeckOfCards()
        let expectedResult = viewModel.currentActiveDeck
        XCTAssert(!expectedResult.isEmpty)
    }
    func testRandomArray() {
        let actualRandomArray = [98, 55, 78, 34, 23, 23, 98, 55, 78, 34, 23, 23]
        self.viewModel.createDeckOfCards()
        let expectedArray = viewModel.randomArray
        XCTAssert(expectedArray.count != 0)
        XCTAssertEqual(expectedArray.count, actualRandomArray.count)
        XCTAssertNotEqual(actualRandomArray, expectedArray)
    }
    func testCheckCards() {
        var cardOne: Card = Card(value: 20)
        cardOne.cardId = 1
        cardOne.flipped = false
        var cardTwo: Card = Card(value: 22)
        cardTwo.cardId = 2
        cardTwo.flipped = false
        let actualArray: [Card] = [cardTwo]
        self.viewModel.currentActiveChosenCards = [cardTwo]
        XCTAssertEqual(actualArray, self.viewModel.currentActiveChosenCards)
        self.viewModel.currentActiveChosenCardsIdx = [IndexPath(row: 1, section: 1)]
        XCTAssertEqual([IndexPath(row: 1, section: 1)], self.viewModel.currentActiveChosenCardsIdx)
        self.viewModel.selectCard(card: cardOne, indexPath: IndexPath(row: 0, section: 1))
    }
    func testCheckIfMatchTrue() {
        var cardOne: Card = Card(value: 22)
        cardOne.cardId = 1
        cardOne.flipped = false
        var cardTwo: Card = Card(value: 22)
        cardTwo.cardId = 2
        cardTwo.flipped = false
        self.viewModel.currentActiveChosenCards = [cardOne, cardTwo]
        let expectedResult = self.viewModel.checkIfMatch()
        XCTAssert(expectedResult)
    }
    func testCheckIfMatchFalse() {
        var cardOne: Card = Card(value: 23)
        cardOne.cardId = 1
        cardOne.flipped = false
        var cardTwo: Card = Card(value: 22)
        cardTwo.cardId = 2
        cardTwo.flipped = false
        self.viewModel.currentActiveChosenCards = [cardOne, cardTwo]
        let expectedResult = self.viewModel.checkIfMatch()
        XCTAssertFalse(expectedResult)
        
    }
}
