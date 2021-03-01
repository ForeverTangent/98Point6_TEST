//
//  ViewController.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import UIKit
import os


/**
[This is smart](https://stackoverflow.com/a/53601585/9760718)

No more Selectors
*/
class BindableGestureRecognizer: UITapGestureRecognizer {
	private var action: () -> Void

	init(action: @escaping () -> Void) {
		self.action = action
		super.init(target: nil, action: nil)
		self.addTarget(self, action: #selector(execute))
	}

	@objc private func execute() {
		action()
	}
}


class ViewController: UIViewController {

	// MARK: - Properties
	private let logger = ViewController.getLoggerFor(category: "ViewController")
	static func getLoggerFor(category: String) -> Logger {
		return Logger(subsystem: Bundle.main.bundleIdentifier!, category: category)
	}


	@IBOutlet weak var gameField: UIView!


	// MARK: UI Properties

	private var gameFieldStackView = UIStackView()

	static var numberOfColumns = 4
	static var numberOfRows = 4
	static var numberOfMatches = 4

	var columnWidth: CGFloat {
		return gameField.frame.width / CGFloat(ViewController.numberOfColumns)
	}
	var columnHeight: CGFloat {
		return gameField.frame.width
	}
	var cellWidth: CGFloat {
		return columnWidth
	}
	var cellHeight: CGFloat {
		return columnHeight / CGFloat(ViewController.numberOfRows)
	}

	var isPlayersTurn = false

	var gameDataManager: GameDataManager?
	var networking = Networking()


	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		gameDataManager = GameDataManager(numberOfColumns: ViewController.numberOfColumns,
										  numberOfRows: ViewController.numberOfRows)
		setupGameFieldStackView()


	}


	override func viewDidAppear(_ animated: Bool) {
		presentPassFirstTurnAlert()
	}



	// MARK: - Class Methods

	func presentPassFirstTurnAlert() {
		let alert = UIAlertController(title: "Pass?",
									  message: "Pass first turn?",
									  preferredStyle: .alert)
		let passFirstTurn = UIAlertAction(title: NSLocalizedString("YES", comment: "Server goes First"),
										  style: .default,
										  handler: { _ in
											self.logger.debug("The player passed, server goes first.")
											self.isPlayersTurn = false
											self.processServersTurn()
										  })
		let takeFirstTurn = UIAlertAction(title: NSLocalizedString("NO", comment: "Player goes First"),
										  style: .default,
										  handler: { _ in
											self.logger.debug("The player goes first.")
											self.isPlayersTurn = true
										  })
		alert.addAction(takeFirstTurn)
		alert.addAction(passFirstTurn)
		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}

	enum GameResult: Int {
		case WIN
		case LOSE
		case DRAW
	}

	func presentGameOverWithResult(_ result: GameResult) {
		DispatchQueue.main.async {
			let gameOverMessage: String
			switch result {
				case .WIN:
					gameOverMessage = "You Won!"
				case .LOSE:
					gameOverMessage = "You Lost."
				case .DRAW:
					gameOverMessage = "It is a draw"
			}

			let alert = UIAlertController(title: "\(gameOverMessage)",
										  message: "You want to play again?",
										  preferredStyle: .alert)
			let yesPlayAgain = UIAlertAction(title: NSLocalizedString("YES", comment: "Server goes First"),
											 style: .default,
											 handler: { _ in
												self.logger.debug("The player wants to play again.")
												self.clearGame()
											 })
			alert.addAction(yesPlayAgain)

			self.present(alert, animated: true, completion: nil)
		}
	}


	/**
	Setups up the horizontal gamefield Stack View
	*/
	func setupGameFieldStackView() {
		gameFieldStackView.translatesAutoresizingMaskIntoConstraints = false
		gameFieldStackView.axis = .horizontal
		gameFieldStackView.distribution = .fillEqually

		gameField.addSubview(gameFieldStackView)
		gameFieldStackView.topAnchor.constraint(equalTo: gameField.topAnchor, constant: 0.0).isActive = true
		gameFieldStackView.leadingAnchor.constraint(equalTo: gameField.leadingAnchor, constant: 0.0).isActive = true
		gameFieldStackView.trailingAnchor.constraint(equalTo: gameField.trailingAnchor, constant: 0.0).isActive = true
		gameFieldStackView.bottomAnchor.constraint(equalTo: gameField.bottomAnchor, constant: 0.0).isActive = true

		for index in 0..<ViewController.numberOfColumns {
			let newColumn = createColumn(number: index)
			gameFieldStackView.addArrangedSubview(newColumn)
			accessibilityElements?.append(newColumn)
		}

	}



	/**
	Clear game for new round
	*/
	func clearGame() {
		guard let theGameDataManager = gameDataManager else { return }

		clearField()
		DispatchQueue.main.async {
			theGameDataManager.clearGameData()
			self.presentPassFirstTurnAlert()
		}

	}

	/**
	Servers Turn
	*/
	func processServersTurn() {

		guard let theGameDataManager = gameDataManager else { return }

		let currentMovesForServer = theGameDataManager.getDataForNetwork()

		networking.getNewMovesWithMoves(currentMovesForServer) { (moveResults) in
			switch moveResults {
				case .SUCCESS(let theArray):
					self.processReturnedServerMoveArray(theArray)

				case .NO_MORE_MOVES:
					self.presentGameOverWithResult(.DRAW)

				case .FAILURE(let theError):
					self.logger.error("\(theError.localizedDescription)")
			}

		}

	}


	/**
	Picks off new move from server and processes it.

	- Parameter intArray: [Int]
	- Returns: Int
	*/
	func processReturnedServerMoveArray(_ intArray: [Int]) {
		guard
			let theGameDataManager = gameDataManager,
			let theNewMoveColumn = intArray.last
		else {
			return
		}

		if theGameDataManager.canInsertTokenForPlayer(.P2_SERVER, intoColumn: theNewMoveColumn) {
			let recentMove = theGameDataManager.insertTokenForPlayer(.P2_SERVER, intoColumn: theNewMoveColumn)
			DispatchQueue.main.async {
				self.updateCellAt(row: recentMove.row, column: recentMove.column, withPiece: .P2_SERVER)
				UIAccessibility.post(notification: .announcement, argument: "Server added to column \(theNewMoveColumn)")
			}
			let isWinningMove = theGameDataManager.isWinningMoveFrom(row: recentMove.row,
																	 column: recentMove.column,
																	 gamePiece: .P2_SERVER)
			if isWinningMove {
				presentGameOverWithResult(.LOSE)
			}
			if isGameADraw() {
				presentGameOverWithResult(.DRAW)
			}
		}
		logger.debug("PLAYERS TURN")
		isPlayersTurn = true

	}



	/**
	Process the Player's Selcetion
	- Parameter column: Int
	*/
	func processPlayersSelectionOfColumn(_ column: Int) {

		guard let theGameDataManager = gameDataManager else { return }

		if theGameDataManager.canInsertTokenForPlayer(.PLAYER_1, intoColumn: column) {
			isPlayersTurn = false
			let recentMove = theGameDataManager.insertTokenForPlayer(.PLAYER_1, intoColumn: column)
			DispatchQueue.main.async {
				self.updateCellAt(row: recentMove.row, column: recentMove.column, withPiece: .PLAYER_1)
			}
			let isWinningMove = theGameDataManager.isWinningMoveFrom(row: recentMove.row,
																	 column: recentMove.column,
																	 gamePiece: .PLAYER_1)
			if isWinningMove {
				presentGameOverWithResult(.WIN)
			}
			if isGameADraw() {
				presentGameOverWithResult(.DRAW)
			}

			logger.debug("SERVERS TURN")
			processServersTurn()
		} else {
			UIAccessibility.post(notification: .announcement, argument: "COLUMN FULL")
		}

	}


	/**
	Check if the game is a tie.
	*/
	func isGameADraw() -> Bool {
		guard
			let theGameDataManager = gameDataManager
		else {
			return false
		}

		if !theGameDataManager.areAnyPossibleMovesLeft {
			return true
		}

		return false
	}



	/**
	Create a Vertical Stack View Column of Cells

	- Parameter number: Int
	- Returns: UIView
	*/
	func createColumn(number: Int) -> UIView {

		// Create cells for Column
		var cellsInColumn = [UIView]()

		for _ in 0..<ViewController.numberOfRows {
			let newCell = TokenView()
			newCell.translatesAutoresizingMaskIntoConstraints = false
			newCell.currentPiece = .EMPTY
			newCell.frame = CGRect(x: 0.0,
								   y: 0.0,
								   width: cellWidth,
								   height: cellHeight)
			cellsInColumn.append(newCell)
		}

		// Create Column
		let columnStackView = ColumnStackView(arrangedSubviews: cellsInColumn)
		columnStackView.axis = .vertical
		columnStackView.distribution = .fillEqually
		columnStackView.cellViews = cellsInColumn
		columnStackView.columnNumber = number
		columnStackView.isAccessibilityElement = true
		columnStackView.accessibilityTraits = .button
		columnStackView.accessibilityLabel = "Column \(String(describing: columnStackView.columnNumber))"


		// Add Interaction
		let tap = BindableGestureRecognizer {
			let columnNumber = number
			self.logger.debug("tapped \(columnNumber)")
			if self.isPlayersTurn {
				self.processPlayersSelectionOfColumn(columnNumber)
			}
		}
		columnStackView.addGestureRecognizer(tap)

		return columnStackView

	}


	/**
	Updates the token Column

	- Parameter column: Int
	- Parameter row: Int
	- Parameter gamePiece: GamePiece
	*/
	func updateCellAt(row: Int, column: Int, withPiece gamePiece: GamePiece) {
		let columnStackView = gameFieldStackView.arrangedSubviews[column] as! ColumnStackView
		columnStackView.updateCellInRow(row, withGamePiece: gamePiece)
	}


	/**
	Clears the playing Field for next game.
	*/
	func clearField() {
		for column in 0..<ViewController.numberOfColumns {
			for row in 0..<ViewController.numberOfRows {
				updateCellAt(row: column, column: row, withPiece: .EMPTY)
			}
		}
	}

}
