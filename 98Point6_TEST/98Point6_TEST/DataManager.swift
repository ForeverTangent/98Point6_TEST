//
//  DataManager.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import Foundation


enum GamePiece: Int {
	case EMPTY
	case PLAYER_1
	case PLAYER_2
}

extension GamePiece: CustomStringConvertible {
	var description: String {
		switch self {
			case .EMPTY:
				return "E"
			case .PLAYER_1:
				return "1"
			case .PLAYER_2:
				return "2"
		}
	}
}



class DataManager {

	private var maxArraySize: Int
	public var networkData: [Int]

	private var numberOfColumns: Int
	private var numberOfRows: Int
	public var gameUIData: [[GamePiece]]

	init(numberOfColumns: Int, numberOfRows: Int) {

		self.numberOfColumns = numberOfColumns
		self.numberOfRows = numberOfRows

		self.maxArraySize = numberOfColumns * numberOfRows

		self.networkData = [Int]()

		self.gameUIData = Array(repeating: Array(repeating: GamePiece.EMPTY, count: numberOfColumns), count: numberOfRows)

	}


	private func getDataForColumn(_ columnIndex: Int) -> [GamePiece] {
		var results = [GamePiece]()
		for rowIndex in 0..<numberOfRows {
			let value = gameUIData[rowIndex][columnIndex]
			results.append(value)
		}
		return results
	}


	func updateGameUIDataWithNetworkData(_ networkData: [Int]) {

	}


	private func insertTokenForPlayer(_ player: GamePiece, intoColumn columnIndex: Int) -> Bool {
		let columnData = getDataForColumn(columnIndex)
		if let rowIndex = columnData.firstIndex(of: .EMPTY) {
			gameUIData[rowIndex][columnIndex] = player
			return true
		}
		return false
	}

}


extension DataManager: CustomStringConvertible {
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


extension DataManager {

	#if DEBUG
	public func testGetDataForColumn(_ columnIndex: Int) -> [GamePiece] {
		return getDataForColumn(columnIndex)
	}


	public func testInsertTokenForPlayer(_ player: GamePiece, intoColumn column: Int) -> Bool {
		return insertTokenForPlayer(player, intoColumn: column)
	}

	#endif

}