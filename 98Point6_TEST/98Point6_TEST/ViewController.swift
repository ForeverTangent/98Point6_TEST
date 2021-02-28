//
//  ViewController.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import UIKit



class TokenView: UIImageView {

	let blueImage = #imageLiteral(resourceName: "BLUE_TOKEN")
	let redImage = #imageLiteral(resourceName: "RED_TOKEN")
	let emptyImage = #imageLiteral(resourceName: "EMPTY_TOKEN")

	var currentPiece = GamePiece.EMPTY {
		didSet {
			switch currentPiece {
				case .EMPTY:
					self.image = emptyImage
					self.accessibilityLabel = ""
					self.setNeedsDisplay()
				case .PLAYER_1:
					self.image = redImage
					self.accessibilityLabel = "RED"
					self.setNeedsDisplay()
				case .PLAYER_2:
					self.image = blueImage
					self.accessibilityLabel = "BLUE"
					self.setNeedsDisplay()
			}
		}
	}

	init() {
		super.init(frame: CGRect.zero)
		self.isUserInteractionEnabled = false
		self.isAccessibilityElement = false
		self.accessibilityLabel = "TOKEN"

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}


/**
[This is smart](https://stackoverflow.com/a/53601585/9760718)
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

	var gameFieldStackView = UIStackView()

	var numberOfColumns = 4
	var numberOfRows = 4

	var columnWidth: CGFloat = 0.0
	var columnHeight: CGFloat = 0.0

	var cellWidth: CGFloat = 0.0
	var cellHeight: CGFloat = 0.0




	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		print("gameField.frame: \(gameField.frame)")

		columnWidth = gameField.frame.width / CGFloat(numberOfColumns)
		columnHeight = gameField.frame.width

		cellWidth = columnWidth
		cellHeight = columnHeight / CGFloat(numberOfRows)

		setupRowStackView()

	}


	override func viewWillAppear(_ animated: Bool) {
		updateCellAt(column: 0, row: 0, withPiece: .PLAYER_1)

	}


	// MARK: - Class Methods

	func setupRowStackView() {
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



	func createColumn(number: Int) -> UIView {
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

		let columnStackView = UIStackView(arrangedSubviews: cellsInColumn)
		columnStackView.axis = .vertical
		columnStackView.distribution = .fillEqually
		columnStackView.accessibilityTraits = .button
		columnStackView.accessibilityLabel = "Column \(String(describing: number))"


		let tap = BindableGestureRecognizer {
			let columnNumber = number
			print("tapped \(columnNumber)")
		}

		columnStackView.addGestureRecognizer(tap)

		return columnStackView

	}

	@objc
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
		let uiRowNumber = numberOfRows - row - 1
		let columnView = gameFieldStackView.arrangedSubviews[column] as! UIStackView
		let cell = columnView.arrangedSubviews[uiRowNumber] as! TokenView
		cell.currentPiece = gamePiece
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
	}
}
