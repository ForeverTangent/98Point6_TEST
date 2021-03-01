//
//  _8Point6_TESTTests.swift
//  98Point6_TESTTests
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import XCTest
@testable import _8Point6_TEST

class _98Point6_DataManager_Tests: XCTestCase {

	/**
	Testing Insert Piece
	*/
	func testDataManager_1_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		var tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (0,0))
		tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (1,0))
		tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (2,0))


		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY]
		]
		print(dm.gameUIData)
		XCTAssertTrue(dm.gameUIData == targetData1, "dm.gameUIData != targetData")

	}

	func testDataManager_1_2() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		var tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (0,0))
		tokenLocation = dm.insertTokenForPlayer(.P2_SERVER, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (1,0))
		tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (2,0))


		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY]
		]
		print(dm.gameUIData)
		XCTAssertTrue(dm.gameUIData == targetData1, "dm.gameUIData != targetData")

	}


	func testDataManager_1_3() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)


		var tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (0,0))
		tokenLocation = dm.insertTokenForPlayer(.P2_SERVER, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (1,0))
		tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (2,0))
		tokenLocation = dm.insertTokenForPlayer(.P2_SERVER, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (3,0))


		tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (-1,-1),
					   "Added piece when we should not have been able too")
		tokenLocation = dm.insertTokenForPlayer(.P2_SERVER, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (-1,-1),
					  "Added piece when we should not have been able too")

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY]
		]
		print(dm.gameUIData)
		XCTAssertTrue(dm.gameUIData == targetData1, "dm.gameUIData != targetData")

	}


	/**
	Test Get Column Data
	*/
	func testDataManager_2() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)


		var tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (0,0))
		tokenLocation = dm.insertTokenForPlayer(.P2_SERVER, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (1,0))
		tokenLocation = dm.insertTokenForPlayer(.PLAYER_1, intoColumn: 0)
		XCTAssertTrue(tokenLocation == (2,0))

		let targetData1 = [GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, GamePiece.PLAYER_1, GamePiece.EMPTY]
		let data = dm.testGetDataForColumn(0)
		print(data)
		XCTAssertTrue(data == targetData1, "data != targetData")

	}


	/**
	Insert from Network Data
	*/
	func testDataManager_3() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [0, 1, 2, 0, 1, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let data = dm.gameUIData
		print(data)
		XCTAssertTrue(data == targetData1, "data != targetData")

	}



	/**
	Test Getting Data for Network
	*/
	func testDataManager_4() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [0, 1, 2, 0, 1, 2]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)
		
		let outGoingData = dm.getDataForNetwork()
		print(outGoingData)

		XCTAssertTrue(outGoingData == mockNetworkData, "\(outGoingData) != \(mockNetworkData)")

	}


	/**
	Test Getting Data for Network
	*/
	func testDataManager_5() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [0, 1, 2, 3, 3, 2, 1, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)

		let outGoingData = dm.getDataForNetwork()
		print(outGoingData)

		let target = [0, 1, 2, 3, 1, 0, 3, 2] // Target Data order is different but data is same as mockData

		XCTAssertTrue(outGoingData == target, "\(outGoingData) != \(target)")

	}


	/**
	Test Getting Data for Network
	*/
	func testDataManager_6() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [0, 1, 2, 0, 1]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)

		let outGoingData = dm.getDataForNetwork()
		print(outGoingData)

		XCTAssertTrue(outGoingData == mockNetworkData, "\(outGoingData) != \(mockNetworkData)")
	}



	/**
	Test Game Win Down
	*/
	func testDataManager_7() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [0, 1, 2, 1, 0, 2, 0, 1, 0, 2]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 3, column: 0, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}



	/**
	Test Game Win Diagonal Down, column increasing
	*/
	func testDataManager_8() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [0, 1, 2, 0, 3, 1, 2, 0, 1, 2, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 3, column: 0, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}



	/**
	Test Game column goign to right
	*/
	func testDataManager_9() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [0, 0, 1, 1, 2, 0, 3, 1]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 0, column: 0, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}


	/**
	Test Game column got to left
	*/
	func testDataManager_10() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.EMPTY	, 	GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY,	 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [3, 3, 2, 2, 1, 3, 0, 2]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 0, column: 3, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}


	/**
	Test Game left right starting in middle
	*/
	func testDataManager_11_A() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.EMPTY	, 	GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY,	 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [3, 3, 2, 2, 1, 3, 0, 2]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 0, column: 2, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}

	/**
	Test Game left right starting in middle
	*/
	func testDataManager_11_B() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.EMPTY	, 	GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY,	 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [3, 3, 2, 2, 1, 3, 0, 2]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 0, column: 1, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}



	/**
	Test Game diagonal row and column decreasing
	*/
	func testDataManager_12_A() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.EMPTY	, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.PLAYER_1]
		]

		let mockNetworkData = [3, 3, 2, 3, 3, 2, 2, 1, 1, 1, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 3, column: 3, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}


	/**
	Test Game diagonal row and column increasing
	*/
	func testDataManager_12_B() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.EMPTY	, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.PLAYER_1]
		]

		let mockNetworkData = [3, 3, 2, 3, 3, 2, 2, 1, 1, 1, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 0, column: 0, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}


	/**
	Test Game diagonal row increasing and and column decreasing
	*/
	func testDataManager_13_A() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1 , 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [3, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 3, column: 0, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}

	/**
	Test Game diagonal row decreasing and and column increasing
	*/
	func testDataManager_13_B() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1 , 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [3, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 0, column: 3, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}


	/**
	In the middle of
	Test Game diagonal row increasing and and column decreasing/Test Game diagonal row decreasing and and column increasing
	*/
	func testDataManager_13_C() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1 , 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [3, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 1, column: 2, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}



	/**
	In the middle of
	Test Game diagonal row increasing and and column decreasing/Test Game diagonal row decreasing and and column increasing
	*/
	func testDataManager_13_D() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1 , 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let mockNetworkData = [3, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let win = dm.isWinningMoveFrom(row: 2, column: 1, gamePiece: .PLAYER_1)

		XCTAssertTrue(win, "No Win something is wrong")

	}


	/**
	Test for draw game
	*/
	func testDataManager_13() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1,	 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER]
		]

		let mockNetworkData = [0, 1, 2, 3,
							   1, 0, 2, 3,
							   1, 0, 3, 2,
							   0, 1, 2, 3]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.gameUIData
		print(data)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		print(dm)

		var player1ShouldBeFalse = dm.isWinningMoveFrom(row: 3, column: 0, gamePiece: .PLAYER_1)

		XCTAssertFalse(player1ShouldBeFalse, "No Win should be possible.")

		var player2ShouldBeFalse = dm.isWinningMoveFrom(row: 3, column: 3, gamePiece: .P2_SERVER)

		XCTAssertFalse(player2ShouldBeFalse, "No Win should be possible.")

		
		player2ShouldBeFalse = dm.isWinningMoveFrom(row: 3, column: 1, gamePiece: .P2_SERVER)

		XCTAssertFalse(player2ShouldBeFalse, "No Win should be possible.")

		player1ShouldBeFalse = dm.isWinningMoveFrom(row: 3, column: 2, gamePiece: .PLAYER_1)

		XCTAssertFalse(player1ShouldBeFalse, "No Win should be possible.")


	}



	/**
	Any moves Left?
	*/
	func testDataManager_14() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [
			0, 1, 2, 3,
			0, 1, 2, 3,
			0, 1, 2, 3,
			0, 1, 2, 3
		]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let movesLeft = dm.areAnyPossibleMovesLeft

		XCTAssertFalse(movesLeft, "there should NOT be any moves left.")

	}

	/**
	Any moves Left?
	*/
	func testDataManager_15() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [
			0, 1, 2, 3,
			0, 1, 2, 3,
			0, 1, 2, 3,
			0, 1, 2
		]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let movesLeft = dm.areAnyPossibleMovesLeft

		XCTAssertTrue(movesLeft, "there are 1 moves left.")

	}


	/**
	Any moves Left?
	*/
	func testDataManager_16() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [Int]()

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let movesLeft = dm.areAnyPossibleMovesLeft

		XCTAssertTrue(movesLeft, "there are many moves left.")

	}




}
