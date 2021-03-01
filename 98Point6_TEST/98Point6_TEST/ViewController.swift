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

	@IBOutlet weak var infoButton: UIButton!
	@IBOutlet weak var gameField: UIView!


	// MARK: UI Properties

	var gameFieldStackView = UIStackView()
	var numberOfColumns = 4
	var numberOfRows = 4
	var columnWidth: CGFloat = 0.0
	var columnHeight: CGFloat = 0.0
	var cellWidth: CGFloat = 0.0
	var cellHeight: CGFloat = 0.0

	var dataManager: GameDataManager?
	var networking = Networking()


	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		dataManager = GameDataManager(numberOfColumns: numberOfColumns, numberOfRows: numberOfRows)

		print("gameField.frame: \(gameField.frame)")

		columnWidth = gameField.frame.width / CGFloat(numberOfColumns)
		columnHeight = gameField.frame.width

		cellWidth = columnWidth
		cellHeight = columnHeight / CGFloat(numberOfRows)

		setupGameFieldStackView()

		networking.networkDelegate = self

	}

	override func viewWillAppear(_ animated: Bool) {
		updateCellAt(column: 0, row: 0, withPiece: .PLAYER_1)
		updateCellAt(column: 0, row: 1, withPiece: .PLAYER_1)
		updateCellAt(column: 0, row: 2, withPiece: .PLAYER_1)

//		updateCellAt(column: 0, row: 1, withPiece: .PLAYER_2)
//		updateCellAt(column: 0, row: 2, withPiece: .PLAYER_1)
//
//		let currentMoves = [0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
//
//		networking.getNewMovesWithMoves(currentMoves) { (result) in
//			switch result {
//				case .SUCCESS(let theData):
//					print("theData \(theData)")
//				case .NO_MORE_MOVES:
//					print("No More Moves")
//				case .FAILURE(let theError):
//					print("theError \(theError)")
//			}
//		}


//		let winning = isWinningMoveFrom(row: 2, column: 0, gamePiece: .PLAYER_1)

	}


	// MARK: - Class Methods

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

		for index in 0..<numberOfColumns {
			let newColumn = createColumn(number: index)
			gameFieldStackView.addArrangedSubview(newColumn)
		}

	}





	/**
	Create a Vertical Stack View Column of Cells

	- Parameter number: Int
	- Returns: UIView
	*/
	func createColumn(number: Int) -> UIView {

		// Create cells for Column
		var cellsInColumn = [UIView]()

		for _ in 0..<numberOfRows {
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
	func updateCellAt(column: Int, row: Int, withPiece gamePiece: GamePiece) {
		let columnStackView = gameFieldStackView.arrangedSubviews[column] as! ColumnStackView
		columnStackView.updateCellInRow(row, withGamePiece: gamePiece)
	}


	/**
	Clears the playing Field for next game.
	*/
	func clearField() {
		for column in 0..<numberOfColumns {
			for row in 0..<numberOfRows {
				updateCellAt(column: column, row: row, withPiece: .EMPTY)
			}
		}
	}

}



extension ViewController: NetworkingDelagate {
	func reportTheReturnedMoves(_ moves: [Int]) {
		print("moves: \(moves)")
	}
}
