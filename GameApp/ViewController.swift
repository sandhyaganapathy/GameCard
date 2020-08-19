//
//  ViewController.swift
//  GameApp
//
//  Created by venao8 on 18/8/20.
//  Copyright © 2020 sandhya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game"
        
    }
    @IBAction func CardGame(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cardViewContrroller = storyboard.instantiateViewController(withIdentifier: "GameCardViewController")
        self.navigationController?.pushViewController(cardViewContrroller, animated: true)
    }
}

