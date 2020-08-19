//
//  GameCardCollectionViewCell.swift
//  card
//
//  Created by venao8 on 18/8/20.
//  Copyright © 2020 sandhya. All rights reserved.
//

import UIKit

class GameCardCollectionViewCell: UICollectionViewCell {
    var cardViews : (frontView: UIImageView, backView: UIImageView)?
    var imgViewFront: UIImageView = {
        var imgViewFront = UIImageView()
        imgViewFront.image = UIImage(named: "Front")
        imgViewFront.contentMode = .scaleAspectFill
        imgViewFront.layer.cornerRadius = 5.0
        imgViewFront.layer.borderWidth = 5.0
        imgViewFront.layer.borderColor = UIColor.black.cgColor
        imgViewFront.clipsToBounds = true
        imgViewFront.translatesAutoresizingMaskIntoConstraints = false
        return imgViewFront
    }()
    
    var imgViewBack: UIImageView = {
        let imgViewBack = UIImageView()
        imgViewBack.image = UIImage(named: "Back")
        imgViewBack.contentMode = .scaleAspectFill
        imgViewBack.layer.cornerRadius = 5.0
        imgViewBack.layer.borderWidth = 5.0
        imgViewBack.layer.borderColor = UIColor.white.cgColor
        imgViewBack.clipsToBounds = true
        imgViewBack.translatesAutoresizingMaskIntoConstraints = false
        return imgViewBack
    }()
    var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addViews() {
        self.cardViews = (frontView: imgViewFront, backView: imgViewBack)
        self.imgViewFront.addSubview(valueLabel)
        self.contentView.addSubview(imgViewBack)
        
        imgViewBack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imgViewBack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imgViewBack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        valueLabel.centerXAnchor.constraint(equalTo: imgViewFront.centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: imgViewFront.centerYAnchor).isActive = true
    }
    func setCardCell(card: Card) {
        self.valueLabel.text = String(card.value)
    }
    func flipCardAnimation(indexPath: IndexPath) {
        if (self.imgViewBack.superview != nil) {
            self.cardViews = (frontView: self.imgViewFront, backView: self.imgViewBack)
        } else {
            self.cardViews = (frontView: self.imgViewBack, backView: self.imgViewFront)
        }
        let transitionOptions = UIView.AnimationOptions.transitionFlipFromLeft
        UIView.transition(with: self.contentView, duration: 0.5, options: transitionOptions, animations: {
            self.cardViews!.backView.removeFromSuperview()
            self.contentView.addSubview(self.cardViews!.frontView)
        }, completion: { finished in
            print(indexPath)
        })
    }
}
