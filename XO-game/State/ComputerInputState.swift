//
//  ComputerInputState.swift
//  XO-game
//
//  Created by Максим Лосев on 27.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class ComputerInputState: GameState {
    
    //MARK: - Properties
    
    let markViewPrototype: MarkView
    
    let player: Player
    
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    var isCompleted: Bool = false
    
    //MARK: - Constructions
    
    init(player: Player,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView,
         markViewPrototype: MarkView) {
        self.player = player
        self.gameboard = gameboard
        self.gameViewController = gameViewController
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    //MARK: - Functions
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
            gameViewController?.winnerLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.text = "Computer"
            gameViewController?.winnerLabel.isHidden = true
            
            guard let gameboardView = gameboardView else {
                return
            }
            let position = gameboardView.createRamdonPosition()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                gameboardView.onSelectPosition?(position)
            }
        }
    }
    
    func addMark(at position: GameboardPosition) {
        log(.playerInput(play: player, position: position))
        guard let gameboardView = gameboardView,
              gameboardView.canPlaceMarkView(at: position) else {
            return
        }
        
        gameboard?.setPlayer(player, at: position)
        gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
        isCompleted = true
    }
    
}
