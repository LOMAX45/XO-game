//
//  ShowGameState.swift
//  XO-game
//
//  Created by Максим Лосев on 29.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class ShowGameState: GameState {
    
    //MARK: - Properties
    
    var isCompleted: Bool = false
    
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    var positions = [GameboardPosition]()
    
    var player: Player?
    
    var checkUser = 0
    
    //MARK: - Constructors
    
    init(gameViewController: GameViewController,
         gameboard: Gameboard?,
         gameboardView: GameboardView?, positions: [GameboardPosition]) {
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.positions = positions
    }
    
    //MARK: - Functions
    
    func begin() {
        gameViewController?.winnerLabel.isHidden = true
        gameViewController?.secondPlayerTurnLabel.isHidden = true
        gameViewController?.firstPlayerTurnLabel.isHidden = true
        positions = sortPositions(at: positions)
        isCompleted = true
    }
    
    func addMark(at position: GameboardPosition) {
        if let gameboardView = self.gameboardView,
           !gameboardView.canPlaceMarkView(at: position) {
            gameboardView.removeMarkView(at: position)
        }
        
        if self.checkUser % 2 == 0 {
            self.player = .first
        } else {
            self.player = .second
        }
        guard let player = self.player,
              let gameboardView = self.gameboardView else { return }
        log(.playerInput(play: player, position: position))
        self.gameboard?.setPlayer(player, at: position)
        gameboardView.placeMarkView(player.markViewPrototype.copy(), at: position)
        self.checkUser += 1
    }
    
    //MARK: - Private functions
    
    func sortPositions(at array: [GameboardPosition]) -> [GameboardPosition] {
        var positionsSorted: [GameboardPosition] = []
        positionsSorted.append(positions[0])
        positionsSorted.append(positions[5])
        positionsSorted.append(positions[1])
        positionsSorted.append(positions[6])
        positionsSorted.append(positions[2])
        positionsSorted.append(positions[7])
        positionsSorted.append(positions[3])
        positionsSorted.append(positions[8])
        positionsSorted.append(positions[4])
        positionsSorted.append(positions[9])
        return positionsSorted
    }
    
}
