//
//  CardViewController.swift
//  card
//
//  Created by venao8 on 18/8/20.
//  Copyright © 2020 sandhya. All rights reserved.
//

import UIKit
private let reuseIdentifier = "GameCardCollectionViewCell"
class GameCardViewController: UIViewController {
    var cardViewModel = GameCardViewModel()
    var currentGameState: GameState = .NotPlaying
    
    @IBOutlet weak var stepsLabel: UILabel! {
        didSet {
            stepsLabel.numberOfLines = 1
            stepsLabel.font  = UIFont.init(name: "Arial", size: 17.0)
            stepsLabel.textColor = UIColor.black
            stepsLabel.text = "Steps: \(self.cardViewModel.record)"
        }
    }
    @IBOutlet weak var restartButton: UIButton! {
        didSet {
            restartButton.setTitle("Ready?", for: .normal)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(GameCardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            if #available(iOS 13.0, *) {
                self.collectionView.automaticallyAdjustsScrollIndicatorInsets = false
            } else {
                // Fallback on earlier versions
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.title = "Card Game"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cardViewModel.createDeckOfCards()
        self.collectionView.reloadData()
    }
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onMisMatch), name: Notification.Name.init(Constants.kMisMatchNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onMatch), name: Notification.Name.init(Constants.kMatchNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onGameEnd), name: Notification.Name.init(Constants.kGameEndNotificationName), object: nil)
    }
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(Constants.kMisMatchNotificationName), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(Constants.kMatchNotificationName), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(Constants.kGameEndNotificationName), object: nil)
    }
    @objc func onMatch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your function here
            print("Match Over")
        }
    }
    @objc func onMisMatch() {
        for indexPath in self.cardViewModel.currentActiveChosenCardsIdx {
            if let cell = self.collectionView.cellForItem(at: indexPath) as? GameCardCollectionViewCell {
                cell.flipCardAnimation(indexPath: indexPath)
            }
        }
        self.cardViewModel.currentActiveChosenCardsIdx.removeAll()
    }
    @objc func onGameEnd() {
        self.restartButton.setTitle("Restart", for: .normal)
        currentGameState = .GameEnd
        self.collectionView.isUserInteractionEnabled = false
    }
    @objc func onReset(_ sender: AnyObject) {
        if currentGameState == .Playing || currentGameState == .GameEnd {
            let alertView = UIAlertController(title: "Are you sure?", message: "Restart Game?", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                for unflippedCard in self.cardViewModel.flippedCards {
                    let cell = self.collectionView?.cellForItem(at: unflippedCard) as! GameCardCollectionViewCell
                    cell.flipCardAnimation(indexPath: unflippedCard)
                }
                self.cardViewModel.createDeckOfCards()
                self.collectionView.reloadData()
                self.currentGameState = .NotPlaying
                self.restartButton.setTitle("Ready?", for: .normal)
                self.cardViewModel.record = 0
                self.stepsLabel.text = "Steps: \(self.cardViewModel.record)"
                self.collectionView.isUserInteractionEnabled = true
            })
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                
            })
            alertView.addAction(actionYes)
            alertView.addAction(actionNo)
            present(alertView, animated: true, completion: nil)
        }
    }
    deinit {
        self.removeObservers()
    }
}
// MARK: COLLECTION VIEW DATASOURCE
extension GameCardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cardViewModel.currentActiveDeck.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GameCardCollectionViewCell {
            let card = self.cardViewModel.currentActiveDeck[indexPath.row]
            cell.setCardCell(card: card)
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentGameState == .NotPlaying {
            currentGameState = .Playing
            self.restartButton.setTitle("Stop", for: .normal)
        }
        if !self.cardViewModel.currentActiveChosenCardsIdx.contains(indexPath) && !self.cardViewModel.flippedCards.contains(indexPath){
            if  let cell = collectionView.cellForItem(at: indexPath) as? GameCardCollectionViewCell{
                let card = self.cardViewModel.currentActiveDeck[indexPath.row]
                if self.cardViewModel.currentActiveChosenCards.count <= 1 {
                    if self.cardViewModel.currentActiveChosenCards.count == 1 {
                        if self.cardViewModel.currentActiveChosenCards[0].cardId != card.cardId {
                            cell.flipCardAnimation(indexPath: indexPath)
                            self.cardViewModel.selectCard(card: card, indexPath: indexPath)
                            self.stepsLabel.text = "Steps: \(self.cardViewModel.record)"
                        }
                    } else {
                        cell.flipCardAnimation(indexPath: indexPath)
                        self.cardViewModel.selectCard(card: card, indexPath: indexPath)
                        self.stepsLabel.text = "Steps: \(self.cardViewModel.record)"
                    }
                }
            }
        }
    }
}
