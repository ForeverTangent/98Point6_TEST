//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

protocol GameState {

	var gameMachine: GameMachine

	func passFirstMove(_ firstMove: Bool)
	func enterMove(columnNumber: Int)
	func playAgain()

}


class GameMachine {

	var startState = StartState()
	var inState = InGameState()
	var gameOverState = GameOverState()
	
	private var currentState: State?

	func setGameState(_ state: GameState) {
		currentState = state
	}

}


class StartState: GameState {

	var gameMachine: GameMachine

	func passFirstMove(_ firstMove: Bool) {
		gameMachine.isPlayersMove = false
		gameMachine.setGameState(gameMachine.inState)
	}

	func enterMove(columnNumber: Int) {
	}

	func playAgain() {
	}

}


class InGameState: GameState {
	func passFirstMove(_ firstMove: Bool) { }

	func enterMove(columnNumber: Int) {

	}

	func playAgain() { }
}


class GameOverState: GameState {
	func passFirstMove(_ firstMove: Bool) { }

	func enterMove(columnNumber: Int) { }
	func playAgain() {
		gameMachine.setGameState(gameMachine.playAgain)
	}

}




//: [Next](@next)
