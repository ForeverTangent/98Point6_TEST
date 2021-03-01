//
//  ViewController.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import UIKit


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

	var isPlayersTurn = true

	var gameDataManager: GameDataManager?
	var networking = Networking()


	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		gameDataManager = GameDataManager(numberOfColumns: ViewController.numberOfColumns,
										  numberOfRows: ViewController.numberOfRows)
		setupGameFieldStackView()
//		networking.networkDelegate = self

	}

	override func viewWillAppear(_ animated: Bool) {

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
											NSLog("The player passed, server goes first.")
											self.processServersTurn()
										  })
		let takeFirstTurn = UIAlertAction(title: NSLocalizedString("NO", comment: "Player goes First"),
										  style: .default,
										  handler: { _ in
											NSLog("The player goes first.")
										  })
		alert.addAction(takeFirstTurn)
		alert.addAction(passFirstTurn)
		self.present(alert, animated: true, completion: nil)
	}


	func playAgainAlert() {
		let alert = UIAlertController(title: "Play again?",
									  message: "You want to play again?",
									  preferredStyle: .alert)
		let yesPlayAgain = UIAlertAction(title: NSLocalizedString("YES", comment: "Server goes First"),
										  style: .default,
										  handler: { _ in
											NSLog("The player wants to play again.")
										  })
		alert.addAction(yesPlayAgain)
		self.present(alert, animated: true, completion: nil)
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
		}

	}



	func processServersTurn() {

		guard let theDataManager = gameDataManager else { return }

		let currentMovesForServer = theDataManager.getDataForNetwork()
		print(currentMovesForServer)

		networking.getNewMovesWithMoves(currentMovesForServer) { (moveResults) in
			switch moveResults {
				case .SUCCESS(let theArray):
					print("theArray \(theArray)")
					self.processReturnedMovesArray(theArray)
				case .NO_MORE_MOVES:
					print("Must be a draw")
				case .FAILURE(let theError):
					print(theError)
			}

		}

	}


	/**
	Picks off new move from server and processes it.

	- Parameter intArray: [Int]
	- Returns: Int
	*/
	func processReturnedMovesArray(_ intArray: [Int]) {
		guard
			let theNewMove = intArray.last,
			let theGameDataManager = gameDataManager
		else {
			return
		}

		let uiLocation: (row: Int, column: Int)
		let winningMove: Bool

		if isPlayersTurn {
			uiLocation = theGameDataManager.insertTokenForPlayer(.PLAYER_1, intoColumn: theNewMove)
			DispatchQueue.main.async {
				self.updateCellAt(row: uiLocation.row, column: uiLocation.column, withPiece: .PLAYER_1)
			}
			winningMove = theGameDataManager.isWinningMoveFrom(row: uiLocation.row,
															   column: uiLocation.column,
															   gamePiece: .PLAYER_1)
		} else {
			uiLocation = theGameDataManager.insertTokenForPlayer(.PLAYER_1, intoColumn: theNewMove)
			DispatchQueue.main.async {
				self.updateCellAt(row: uiLocation.row, column: uiLocation.column, withPiece: .PLAYER_2)
			}
			winningMove = theGameDataManager.isWinningMoveFrom(row: uiLocation.row,
															   column: uiLocation.column,
															   gamePiece: .PLAYER_2)
		}

		print("uiLocation \(uiLocation)")
		print("theNewMove: \(theNewMove)")
		print("winningMove \(winningMove)")

		
	}



	func processPlayersSelectionOfColumn(_ column: Int) {

	}



	func gameIsADraw() {
		
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
		columnStackView.accessibilityTraits = .button
		columnStackView.accessibilityLabel = "Column \(String(describing: columnStackView.columnNumber))"


		// Add Interaction
		let tap = BindableGestureRecognizer {
			let columnNumber = number
			print("tapped \(columnNumber)")
		}
		columnStackView.addGestureRecognizer(tap)

		return columnStackView

	}

	@objc
	/**
	What happens when you tap a column,
	*/
	func tappedColumn() {

		print("Column Tapped")

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



//extension ViewController: NetworkingDelagate {
//	func reportTheReturnedMoves(_ moves: [Int]) {
//		print("moves: \(moves)")
//	}
//}
