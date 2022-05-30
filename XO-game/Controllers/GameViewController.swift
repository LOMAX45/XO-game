//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    //MARK: - Properties
    
    var gameType: GameType?
    var firstPlayerPositions = [GameboardPosition]()
    var secondPlayerPositions = [GameboardPosition]()
    
    //MARK: - Private properties
    
    private lazy var referee = Referee(gameboard: gameBoard)
    private let gameBoard = Gameboard()
    private var currentState: GameState! {
        didSet {
            currentState.begin()
            
            if currentState is ShowGameState {
                showGame()
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        log(.restartGame)
    }
    
    //MARK: - Private functions
    
    private func goToNextState() {
        if gameType != .multiTouchesGame, let winner = referee.determineWinner() {
            currentState = GameEndedState(winner: winner,
                                          gameViewController: self)
            return
        } else {
            if let multiTouchedState = self.currentState as? MultiTouchesState,
               multiTouchedState.player == .second,
               multiTouchedState.counter == 5 {
                currentState = ShowGameState(gameViewController: self, gameboard: gameBoard, gameboardView: gameboardView, positions: firstPlayerPositions + secondPlayerPositions)
                return
            }
        }
        
        switch gameType {
        case .twoPlayersGame:
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                
                currentState = PlayerInputState(player: player,
                                                gameViewController: self,
                                                gameboard: gameBoard,
                                                gameboardView: gameboardView,
                                                markViewPrototype: player.markViewPrototype)
            }
        case .vsComputerGame:
            if let computerInputState = currentState as? ComputerInputState {
                let player = computerInputState.player.next
                
                currentState = ComputerInputState(player: player,
                                                  gameViewController: self,
                                                  gameboard: gameBoard,
                                                  gameboardView: gameboardView,
                                                  markViewPrototype: player.markViewPrototype)
            }
        case .none:
            break
        case .multiTouchesGame:
            if let multiTouchesState = currentState as? MultiTouchesState {
                let player = multiTouchesState.player.next
                currentState = MultiTouchesState(player: player,
                                                 gameViewController: self,
                                                 gameboard: gameBoard)
            }
        }
    }
    
    private func goToFirstState() {
        let player: Player = .first
        
        switch gameType {
        case .twoPlayersGame:
            currentState = PlayerInputState(player: player,
                                            gameViewController: self,
                                            gameboard: gameBoard,
                                            gameboardView: gameboardView,
                                            markViewPrototype: player.markViewPrototype)
        case .vsComputerGame:
            currentState = ComputerInputState(player: player,
                                              gameViewController: self,
                                              gameboard: gameBoard,
                                              gameboardView: gameboardView,
                                              markViewPrototype: player.markViewPrototype)
        case .none:
            break
        case .multiTouchesGame:
            currentState = MultiTouchesState(player: player,
                                             gameViewController: self,
                                             gameboard: gameBoard)
        }
    }
    
    private func showGame() {
        guard let showGameState = currentState as? ShowGameState,
              showGameState.isCompleted == true else { return }
        let sortedPositions = showGameState.positions
        
        for position in sortedPositions {
                showGameState.addMark(at: position)
            if let winner = referee.determineWinner() {
                currentState = GameEndedState(winner: winner,
                                              gameViewController: self)
                return
            }
        }
    }
    
}

