//
//  MultiTouchesState.swift
//  XO-game
//
//  Created by Максим Лосев on 29.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class MultiTouchesState: GameState {
    
    
    //MARK: - Properties
    
    let player: Player
    
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    
    var isCompleted: Bool = false
    
    var counter = 0
    
    //MARK: - Constructions
    init(player: Player,
         gameViewController: GameViewController,
         gameboard: Gameboard){
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
    }
    
    //MARK: - Functions
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        gameViewController?.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        switch player {
        case .first:
            gameViewController?.firstPlayerPositions.append(position)
        case .second:
            gameViewController?.secondPlayerPositions.append(position)
        }
        counter += 1
        if counter == 5 {
            isCompleted = true
        }
    }

}
