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

	private var numberOfColumns: Int
	private var numberOfRows: Int

	private var maxArraySize: Int {
		get {
			numberOfColumns * numberOfRows
		}
	}
	public var networkData: [Int] {
		get {
			return getDataForNetwork()
		}
	}

	private var tokensEntered = 0

	public var areAnyPossibleMovesLeft: Bool {
		get {
			return tokensEntered != maxArraySize
		}
	}


	public var gameUIData: [[GamePiece]]


	// MARK: - Inits

	init(numberOfColumns: Int, numberOfRows: Int) {

		self.numberOfColumns = numberOfColumns
		self.numberOfRows = numberOfRows

		self.gameUIData = Array(repeating: Array(repeating: GamePiece.EMPTY, count: numberOfColumns), count: numberOfRows)

	}

	// MARK: - Class Methods


	/**
	Clear Game data for a new round.
	*/
	func clearGameData() {
		self.gameUIData = Array(repeating: Array(repeating: GamePiece.EMPTY, count: numberOfColumns), count: numberOfRows)
		tokensEntered = 0
//		print(self.gameUIData)
	}


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
	- Parameter networkData: [Int]
	*/
	func updateGameUIDataWithNetworkData(_ networkData: [Int]) {
		for index in 0..<networkData.count {
			let columnValue = networkData[index]
			if index % 2 == 0 { 											// Player 1, remember index offset by 1.
				insertTokenForPlayer(.PLAYER_1, intoColumn: columnValue)
			} else { 														// Player 2
				insertTokenForPlayer(.P2_SERVER, intoColumn: columnValue)
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
	func insertTokenForPlayer(_ player: GamePiece, intoColumn columnIndex: Int) -> (row: Int, column: Int) {
		let columnData = getDataForColumn(columnIndex)
		if let rowIndex = columnData.firstIndex(of: .EMPTY) {
			gameUIData[rowIndex][columnIndex] = player
			tokensEntered += 1
			return (row: rowIndex, column: columnIndex)
		}

		return (row: -1, column: -1)
	}


	func canInsertTokenForPlayer(_ player: GamePiece, intoColumn columnIndex: Int) -> Bool {
		let columnData = getDataForColumn(columnIndex)
		if columnData.firstIndex(of: .EMPTY) != nil {
			return true
		}
		return false
	}



	func isAnyPossibleMovesLeft() -> Bool {
		return maxArraySize == networkData.count
	}


	/**
	Process the internal game represenation for something we can send to the server.
	- Returns: [Int]
	*/
	func getDataForNetwork() -> [Int] {

		if gameUIData.isEmpty { return [Int]() }

		let player1Queue = Queue<Int>()
		let player2Queue = Queue<Int>()

		for row in 0..<numberOfRows {
			for column in 0..<numberOfColumns {
				switch gameUIData[row][column] {
					case .PLAYER_1:
						player1Queue.push(column)
					case .P2_SERVER:
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


	// MARK: Game Logic Win/Lose Checking




	/**
	Fun with recursion. to check if there is a win.

	- Parameter gamePiece: GamePiece, being checked.
	- Parameter row: Int,
	- Parameter column: Int,
	- Parameter x: Int, (x direction to search)
	- Parameter y: Int (y direction to search)
	- Returns: Int, the number of Matches
	*/
	private func getNumberOfMatchesOf(gamePiece: GamePiece,
									  startingAtRow row: Int,
									  andColumn column: Int,
									  inDirectionColX x: Int,
									  andRowY y: Int) -> Int {

		guard
			!(x == 0 && y == 0),
			0 <= column && column < numberOfColumns,
			0 <= row && row < numberOfRows
		else {
			return 0
		}

		var results = 0

		if gameUIData[row][column] == gamePiece {
			results += 1

			results += getNumberOfMatchesOf(gamePiece: gamePiece,
											startingAtRow: row + y,
											andColumn: column + x,
											inDirectionColX: x,
											andRowY: y)
		} 

		return results

	}



	private func checkingDown(row: Int,
							  column:Int,
							  gamePiece: GamePiece,
							  targetMatches: Int = ViewController.numberOfMatches) -> Bool {

		var startingCount = 0
		var totalCount = 0

		if gameUIData[row][column] == gamePiece {
			startingCount = 1
		}

		// Straight Down
		let downMatches = getNumberOfMatchesOf(gamePiece: .PLAYER_1,
											   startingAtRow: row - 1,
											   andColumn: column,
											   inDirectionColX: 0,
											   andRowY: -1)
		totalCount = startingCount + downMatches
		if totalCount >= targetMatches {
			return true
		}

		return false

	}



	private func checkingLeftRight(row: Int,
								   column:Int,
								   gamePiece: GamePiece,
								   targetMatches: Int = ViewController.numberOfMatches) -> Bool {

		var startingCount = 0
		var totalCount = 0

		if gameUIData[row][column] == gamePiece {
			startingCount = 1
		}

		// Column increasing
		let columnIncresingMatches = getNumberOfMatchesOf(gamePiece: gamePiece,
														  startingAtRow: row,
														  andColumn: column + 1,
														  inDirectionColX: 1,
														  andRowY: 0)

		// Column decreasing
		let columnDecresingMatches = getNumberOfMatchesOf(gamePiece: gamePiece,
														  startingAtRow: row,
														  andColumn: column - 1,
														  inDirectionColX: -1,
														  andRowY: 0)

		let totalLeftToRight = columnIncresingMatches + columnDecresingMatches
		totalCount = startingCount + totalLeftToRight
		if totalCount >= targetMatches {
			return true
		}

		return false

	}


	/**
	Diagonal -> \

	*/
	private func checkingDiagonal1(row: Int,
								   column:Int,
								   gamePiece: GamePiece,
								   targetMatches: Int = ViewController.numberOfMatches) -> Bool {

		var startingCount = 0
		var totalCount = 0

		if gameUIData[row][column] == gamePiece {
			startingCount = 1
		}

		// Down, Column decreasing
		let downColumnDecresingMatches = getNumberOfMatchesOf(gamePiece: gamePiece,
															  startingAtRow: row - 1,
															  andColumn: column - 1,
															  inDirectionColX: -1,
															  andRowY: -1)

		let upColumnIncreasingMatches = getNumberOfMatchesOf(gamePiece: gamePiece,
															 startingAtRow: row + 1,
															 andColumn: column + 1,
															 inDirectionColX: 1,
															 andRowY: 1)

		let totalDiagonal2 = downColumnDecresingMatches + upColumnIncreasingMatches
		totalCount = startingCount + totalDiagonal2
		if totalCount >= targetMatches {
			return true
		}

		return false

	}


	/**
	Diagonal -> /

	*/
	private func checkingDiagonal2(row: Int,
								   column:Int,
								   gamePiece: GamePiece,
								   targetMatches: Int = ViewController.numberOfMatches) -> Bool {

		var startingCount = 0
		var totalCount = 0

		if gameUIData[row][column] == gamePiece {
			startingCount = 1
		}

		// Down, Column decreasing
		let downColumnDecresingMatches = getNumberOfMatchesOf(gamePiece: gamePiece,
															  startingAtRow: row + 1,
															  andColumn: column - 1,
															  inDirectionColX: -1,
															  andRowY: 1)

		let upColumnIncreasingMatches = getNumberOfMatchesOf(gamePiece: gamePiece,
															 startingAtRow: row - 1,
															 andColumn: column + 1,
															 inDirectionColX: 1,
															 andRowY: -1)

		let totalDiagonal2 = downColumnDecresingMatches + upColumnIncreasingMatches
		totalCount = startingCount + totalDiagonal2
		if totalCount >= targetMatches {
			return true
		}

		return false



	}



	/**
	Checks if there is a win, with recurssion helper.

	- Parameter row: Int, (row of where piece places.
	- Parameter column:Int,  (column of where piece places.
	- Parameter gamePiece: GamePiece,
	- Parameter targetMatches: Int  (Default = ViewController.numberOfMatches, currently = 4)
	- Returns: Bool
	*/
	public func isWinningMoveFrom(row: Int,
								  column:Int,
								  gamePiece: GamePiece,
								  targetMatches: Int = ViewController.numberOfMatches) -> Bool {


		if checkingDown(row: row,
						column: column,
						gamePiece: gamePiece) {
			print("Won Via down starting at \(row), \(column) with \(gamePiece.rawValue)")
			return true
		}


		if checkingLeftRight(row: row,
							 column: column,
							 gamePiece: gamePiece) {
			print("Won Via checkingLeftRight starting at \(row), \(column) with \(gamePiece.rawValue)")
			return true
		}


		if checkingDiagonal1(row: row,
							 column: column,
							 gamePiece: gamePiece) {
			print("Won Via checkingDiagonal1 starting at \(row), \(column) with \(gamePiece.rawValue)")
			return true
		}


		if checkingDiagonal2(row: row,
							 column: column,
							 gamePiece: gamePiece) {
			print("Won Via checkingDiagonal2 starting at \(row), \(column) with \(gamePiece.rawValue)")
			return true
		}

		return false


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



}

// MARK: - Unit Testing

extension GameDataManager {

	#if DEBUG
	public func testGetDataForColumn(_ columnIndex: Int) -> [GamePiece] {
		return getDataForColumn(columnIndex)
	}


	#endif

}
