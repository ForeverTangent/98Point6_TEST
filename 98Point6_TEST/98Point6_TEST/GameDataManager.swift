//
//  DataManager.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import Foundation

/**
Our Data wrangling class.  Because the server wants one thing and the game wants another, and I don't see an clean common DS for all.
*/
class GameDataManager {

	// MARK: - Properties

	private var maxArraySize: Int
	public var networkData: [Int]

	private var numberOfColumns: Int
	private var numberOfRows: Int
	public var gameUIData: [[GamePiece]]


	// MARK: - Inits

	init(numberOfColumns: Int, numberOfRows: Int) {

		self.numberOfColumns = numberOfColumns
		self.numberOfRows = numberOfRows

		self.maxArraySize = numberOfColumns * numberOfRows

		self.networkData = [Int]()

		self.gameUIData = Array(repeating: Array(repeating: GamePiece.EMPTY, count: numberOfColumns), count: numberOfRows)

	}

	// MARK: - Class Methods

	/**
	Gets all the data for one column

	Losest index is bottom row.
	- Parameter columnIndex: Int
	- Returns: [GamePiece]
	*/
	private func getDataForColumn(_ columnIndex: Int) -> [GamePiece] {
		var results = [GamePiece]()
		for rowIndex in 0..<numberOfRows {
			let value = gameUIData[rowIndex][columnIndex]
			results.append(value)
		}
		return results
	}


	/**
	Updates the GameUI data.
	*/
	func updateGameUIDataWithNetworkData(_ networkData: [Int]) {
		for index in 0..<networkData.count {
			let columnValue = networkData[index]
			if index % 2 == 0 { // Player 1, remember index offset by 1.
				insertTokenForPlayer(.PLAYER_1, intoColumn: columnValue)
			} else { // Player 2
				insertTokenForPlayer(.PLAYER_2, intoColumn: columnValue)
			}
		}
	}


	/**
	Inserts a token only if there is a room in column otherwise returns false.

	- Parameter player: GamePiece
	- Parameter columnIndex: Int
	- Returns: Bool, if successful (if not room in column returns false.
	*/
	@discardableResult
	private func insertTokenForPlayer(_ player: GamePiece, intoColumn columnIndex: Int) -> Bool {
		let columnData = getDataForColumn(columnIndex)
		if let rowIndex = columnData.firstIndex(of: .EMPTY) {
			gameUIData[rowIndex][columnIndex] = player
			return true
		}
		return false
	}


	func getDataForNetwork() -> [Int] {

		let player1Queue = Queue<Int>()
		let player2Queue = Queue<Int>()

		for row in 0..<numberOfRows {
			for column in 0..<numberOfColumns {
				switch gameUIData[row][column] {
					case .PLAYER_1:
						player1Queue.push(column)
					case .PLAYER_2:
						player2Queue.push(column)
					default:
						break
				}
			}
		}

		var count = 0
		var results = [Int]()

		while !player1Queue.isEmpty || !player2Queue.isEmpty {
			if
				count % 2 == 0,
				let thePop = player1Queue.pop() {
				results.append(thePop)
			} else if let thePop = player2Queue.pop() {
				results.append(thePop)
			}

			count += 1

		}

		return results
	}


}


// MARK: - CustomStringConvertible

extension GameDataManager: CustomStringConvertible {
	var description: String {
		let network = "NEWTORK: \(networkData)"

		var gameDataOutput = ""
		// Use Stride to flip grid
		for rowIndex in stride(from: numberOfRows-1, to: -1, by: -1) {
			for columnIndex in 0..<numberOfColumns {
				gameDataOutput += "\([gameUIData[rowIndex][columnIndex]])"
			}
			gameDataOutput += "\n"
		}

		let final = """
		\(network)
		GameData:
		\(gameDataOutput)
		"""
		return final
	}


	/**
	Looks like the ugliest recurrsion to me.
	*/
	private func getNumberOfMatchesOf(gamePiece: GamePiece,
									  startingAtRow row: Int,
									  andColumn column: Int,
									  inDirectionColX x: Int,
									  andRowY y: Int) -> Int {

		guard
			x != y,
			0 <= x,
			0 <= y,
			y < numberOfRows,
			x < numberOfColumns else {
			print("You are going no where!")
			return 0
		}

		if
			gameUIData[row][column] == gamePiece {
			return 1 + getNumberOfMatchesOf(gamePiece: gamePiece,
											startingAtRow: row+y,
											andColumn: column+x,
											inDirectionColX: x,
											andRowY: y)
		}

		return 0


	}


	func isWinningMoveFrom(row: Int, column:Int, gamePiece: GamePiece) -> Bool {

		// Left
		var examinedRow = row
		var examinedColumn = column
		var count = 0
		while (0 <= examinedRow && examinedRow < numberOfRows) &&
				(0 <= examinedColumn && examinedColumn < numberOfColumns) {

			if gameUIData[examinedRow][examinedColumn] == gamePiece {
				count += 1
			}

			examinedColumn -= 1
		}
		if count == 4 {
			return true
		}

		// Diagonal Left
		examinedRow = row
		examinedColumn = column
		count = 0
		while (0 <= examinedRow && examinedRow < numberOfRows) &&
				(0 <= examinedColumn && examinedColumn < numberOfColumns) {

			if gameUIData[examinedRow][examinedColumn] == gamePiece {
				count += 1
			}

			examinedRow -= 1
			examinedColumn -= 1
		}
		if count == 4 {
			return true
		}

		// Down
		examinedRow = row
		examinedColumn = column
		count = 0
		while (0 <= examinedRow && examinedRow < numberOfRows) &&
				(0 <= examinedColumn && examinedColumn < numberOfColumns) {

			let examinedCell = gameUIData[examinedRow][examinedColumn]
			if examinedCell == gamePiece {
				count += 1
			}

			examinedRow -= 1
		}
		if count == 4 {
			return true
		}

		// Diagonal Right
		examinedRow = row
		examinedColumn = column
		count = 0
		while (0 <= examinedRow && examinedRow < numberOfRows) &&
				(0 <= examinedColumn && examinedColumn < numberOfColumns) {

			if gameUIData[examinedRow][examinedColumn] == gamePiece {
				count += 1
			}

			examinedRow += 1
			examinedColumn += 1
		}
		if count == 4 {
			return true
		}

		// Right
		examinedRow = row
		examinedColumn = column
		count = 0
		while (0 <= examinedRow && examinedRow < numberOfRows) &&
				(0 <= examinedColumn && examinedColumn < numberOfColumns) {

			if gameUIData[examinedRow][examinedColumn] == gamePiece {
				count += 1
			}

			examinedColumn += 1
		}
		if count == 4 {
			return true
		}

		return false

	}

}

// MARK: - Unit Testing

extension GameDataManager {

	#if DEBUG
	public func testGetDataForColumn(_ columnIndex: Int) -> [GamePiece] {
		return getDataForColumn(columnIndex)
	}


	public func testInsertTokenForPlayer(_ player: GamePiece, intoColumn column: Int) -> Bool {
		return insertTokenForPlayer(player, intoColumn: column)
	}

	#endif

}
