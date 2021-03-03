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

	private let logger = ViewController.getLoggerFor(category: "GameDataManager")

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


	private var gameData: [[GamePiece]]


	// MARK: - Inits

	init(numberOfColumns: Int, numberOfRows: Int) {

		self.numberOfColumns = numberOfColumns
		self.numberOfRows = numberOfRows

		self.gameData = Array(repeating: Array(repeating: GamePiece.EMPTY, count: numberOfColumns), count: numberOfRows)

	}

	// MARK: - Class Methods


	/**
	Clear Game data for a new round.
	*/
	public func clearGameData() {
		self.gameData = Array(repeating: Array(repeating: GamePiece.EMPTY, count: numberOfColumns), count: numberOfRows)
		tokensEntered = 0
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
			let value = gameData[rowIndex][columnIndex]
			results.append(value)
		}
		return results
	}


	/**
	Updates the GameData from returned server data.

	(Honestly, this is only used for testing, but i could be use to set a round in mid game)

	- Parameter networkData: [Int]
	*/
	public func updateGameUIDataWithNetworkData(_ networkData: [Int]) {
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
	public func insertTokenForPlayer(_ player: GamePiece, intoColumn columnIndex: Int) -> (row: Int, column: Int) {
		let columnData = getDataForColumn(columnIndex)
		if let rowIndex = columnData.firstIndex(of: .EMPTY) {
			gameData[rowIndex][columnIndex] = player
			tokensEntered += 1
			return (row: rowIndex, column: columnIndex)
		}

		return (row: -1, column: -1)
	}


	/**
	Can we insert token before we actual do?

	(Helps with checking for a Draw.)

	- Parameter player: GamePiece
	- Parameter columnIndex: Int
	- Returns Bool
	*/
	public func canInsertTokenForPlayer(_ player: GamePiece, intoColumn columnIndex: Int) -> Bool {
		let columnData = getDataForColumn(columnIndex)
		if columnData.firstIndex(of: .EMPTY) != nil {
			return true
		}
		return false
	}



	public func isAnyPossibleMovesLeft() -> Bool {
		return maxArraySize == networkData.count
	}


	/**
	Process the internal game represenation for something we can send to the server.

	Basically takes the GameUIData and turns it into an [Int]

	- Returns: [Int]
	*/
	public func getDataForNetwork() -> [Int] {

		if gameData.isEmpty { return [Int]() }

		let player1Queue = Queue<Int>()
		let player2Queue = Queue<Int>()

		for row in 0..<numberOfRows {
			for column in 0..<numberOfColumns {
				switch gameData[row][column] {
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

	This is main workhorse is checking a player/server has won the game.
	Basically the recurrsion logic is base == 0, recurrsion == +1 + call() for the give direction.

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

		if gameData[row][column] == gamePiece {
			results += 1

			results += getNumberOfMatchesOf(gamePiece: gamePiece,
											startingAtRow: row + y,
											andColumn: column + x,
											inDirectionColX: x,
											andRowY: y)
		} 

		return results

	}


	/**
	Check Down

	- Parameter row: Int, (row of where piece places.
	- Parameter column:Int,  (column of where piece places.
	- Parameter gamePiece: GamePiece,
	- Returns: Bool
	*/
	private func checkingDown(row: Int,
							  column:Int,
							  gamePiece: GamePiece,
							  targetMatches: Int = ViewController.numberOfMatches) -> Bool {

		var startingCount = 0
		var totalCount = 0

		if gameData[row][column] == gamePiece {
			startingCount = 1
		}

		// Straight Down
		let downMatches = getNumberOfMatchesOf(gamePiece: gamePiece,
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


	/**
	Check Left to right and back

	- Parameter row: Int, (row of where piece places.
	- Parameter column:Int,  (column of where piece places.
	- Parameter gamePiece: GamePiece,
	- Returns: Bool
	*/
	private func checkingLeftRight(row: Int,
								   column:Int,
								   gamePiece: GamePiece,
								   targetMatches: Int = ViewController.numberOfMatches) -> Bool {

		var startingCount = 0
		var totalCount = 0

		if gameData[row][column] == gamePiece {
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

	- Parameter row: Int, (row of where piece places.
	- Parameter column:Int,  (column of where piece places.
	- Parameter gamePiece: GamePiece,
	- Returns: Bool
	*/
	private func checkingDiagonal1(row: Int,
								   column:Int,
								   gamePiece: GamePiece,
								   targetMatches: Int = ViewController.numberOfMatches) -> Bool {

		var startingCount = 0
		var totalCount = 0

		if gameData[row][column] == gamePiece {
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

	- Parameter row: Int, (row of where piece places.
	- Parameter column:Int,  (column of where piece places.
	- Parameter gamePiece: GamePiece,
	- Returns: Bool
	*/
	private func checkingDiagonal2(row: Int,
								   column:Int,
								   gamePiece: GamePiece,
								   targetMatches: Int = ViewController.numberOfMatches) -> Bool {

		var startingCount = 0
		var totalCount = 0

		if gameData[row][column] == gamePiece {
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

	This is the top level of the win/lost checking, to check in the all the possible direction a player can win on a token drop.

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
			logger.debug("Won Via down starting at \(row), \(column) with \(gamePiece.rawValue)")
			return true
		}


		if checkingLeftRight(row: row,
							 column: column,
							 gamePiece: gamePiece) {
			logger.debug("Won Via checkingLeftRight starting at \(row), \(column) with \(gamePiece.rawValue)")
			return true
		}


		if checkingDiagonal1(row: row,
							 column: column,
							 gamePiece: gamePiece) {
			logger.debug("Won Via checkingDiagonal1 starting at \(row), \(column) with \(gamePiece.rawValue)")
			return true
		}


		if checkingDiagonal2(row: row,
							 column: column,
							 gamePiece: gamePiece) {
			logger.debug("Won Via checkingDiagonal2 starting at \(row), \(column) with \(gamePiece.rawValue)")
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
				gameDataOutput += "\([gameData[rowIndex][columnIndex]])"
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

// MARK: - Unit Testing Accessors

extension GameDataManager {

	#if DEBUG
	public func testGetDataForColumn(_ columnIndex: Int) -> [GamePiece] {
		return getDataForColumn(columnIndex)
	}

	public func testGetGameData() -> [[GamePiece]] {
		return gameData
	}

	public func testInjectGameData(_ gameData: [[GamePiece]]) {
		self.gameData = gameData
	}

	public func testCheckingDown(row: Int,
								 column:Int,
								 gamePiece: GamePiece) -> Bool {
		return checkingDown(row: row,
							column:column,
							gamePiece: gamePiece)
	}

	public func testCheckingLeftRight(row: Int,
								 column:Int,
								 gamePiece: GamePiece) -> Bool {
		return checkingLeftRight(row: row,
							column:column,
							gamePiece: gamePiece)
	}

	public func testCheckingDiagonal1(row: Int,
									  column:Int,
									  gamePiece: GamePiece) -> Bool {
		return checkingDiagonal1(row: row,
								 column:column,
								 gamePiece: gamePiece)
	}


	public func testCheckingDiagonal2(row: Int,
									  column:Int,
									  gamePiece: GamePiece) -> Bool {
		return checkingDiagonal2(row: row,
								 column:column,
								 gamePiece: gamePiece)
	}



	public func testGetNumberOfMatchesOf(gamePiece: GamePiece,
										 startingAtRow row: Int,
										 andColumn column: Int,
										 inDirectionColX x: Int,
										 andRowY y: Int) -> Int {
		
		return getNumberOfMatchesOf(gamePiece: gamePiece,
									startingAtRow: row,
									andColumn: column,
									inDirectionColX: x,
									andRowY:y)
	}



	#endif

}
