//
//  StartViewController.swift
//  XO-game
//
//  Created by Максим Лосев on 27.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

enum GameType {
    case vsComputerGame, twoPlayersGame
}

class StartViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var vsComputerGameButton: UIButton!
    @IBOutlet weak var twoPlayersGameButton: UIButton!
    
    
    //MARK: - Lificycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    
    @IBAction func vsComputerGameButtonTapped(_ sender: Any) {
        guard let destination = getDestinationController() else { return }
        destination.gameType = .vsComputerGame
        self.present(destination, animated: true)
    }
    
    @IBAction func twoPlayersGameButtonTapped(_ sender: Any) {
        guard let destination = getDestinationController() else { return }
        destination.gameType = .twoPlayersGame
        self.present(destination, animated: true)
    }
    
    //MARK: - Private functions
    
    private func getDestinationController() -> GameViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destination = storyboard.instantiateViewController(withIdentifier: "gameViewController") as? GameViewController else { return nil }
        destination.modalPresentationStyle = .fullScreen
        return destination
    }
}
