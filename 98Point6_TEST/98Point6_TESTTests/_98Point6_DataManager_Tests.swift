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
	func testGameDataManager_InsertPiece_1() {
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
		print(dm.testGetGameUIData())
		XCTAssertTrue(dm.testGetGameUIData() == targetData1, "dm.gameUIData != targetData")

	}

	func testGameDataManager_InsertPiece_2() {
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
		print(dm.testGetGameUIData())
		XCTAssertTrue(dm.testGetGameUIData() == targetData1, "dm.gameUIData != targetData")

	}


	func testGameDataManager_InsertPiece_3() {
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
		print(dm.testGetGameUIData())
		XCTAssertTrue(dm.testGetGameUIData() == targetData1, "dm.gameUIData != targetData")

	}


	/**
	Test Get Column Data
	*/
	func testGameDataManager_GetColumnData_1() {
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
	func testGameDataManager_InsertPiece_FromMockNetworkDat_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [0, 1, 2, 0, 1, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let data = dm.testGetGameUIData()
		print(data)
		XCTAssertTrue(data == targetData1, "data != targetData")

	}



	/**
	Test Getting Data for Network
	*/
	func testGameDataManager_InsertPiece_FromMockNetworkDat_2() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [0, 1, 2, 0, 1, 2]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.testGetGameUIData()
		print(data)
		
		let outGoingData = dm.getDataForNetwork()
		print(outGoingData)

		XCTAssertTrue(outGoingData == mockNetworkData, "\(outGoingData) != \(mockNetworkData)")

	}


	/**
	Test Getting Data for Network
	*/
	func testGameDataManager_InsertPiece_FromMockNetworkDat_3() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [0, 1, 2, 3, 3, 2, 1, 0]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.testGetGameUIData()
		print(data)

		let outGoingData = dm.getDataForNetwork()
		print(outGoingData)

		let target = [0, 1, 2, 3, 1, 0, 3, 2] // Target Data order is different but data is same as mockData

		XCTAssertTrue(outGoingData == target, "\(outGoingData) != \(target)")

	}


	/**
	Test Getting Data for Network
	*/
	func testGameDataManager_InsertPiece_FromMockNetworkDat_4() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [0, 1, 2, 0, 1]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.testGetGameUIData()
		print(data)

		let outGoingData = dm.getDataForNetwork()
		print(outGoingData)

		XCTAssertTrue(outGoingData == mockNetworkData, "\(outGoingData) != \(mockNetworkData)")
	}



	/**
	Test Game Win Down
	*/
	func testGameDataManager_NoWinningGameDown_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 	GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let winTest1 = dm.testCheckingDown(row: 2, column: 0, gamePiece: .PLAYER_1)
		XCTAssertFalse(winTest1, "There SHould no be a win, something is wrong")

		let winTest2 = dm.testCheckingDown(row: 2, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(winTest2, "There SHould no be a win, something is wrong")

	}


	/**
	Test Game Win Down
	*/
	func testGameDataManager_WinningGameDown_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let winTest1 = dm.testCheckingDown(row: 3, column: 0, gamePiece: .PLAYER_1)
		XCTAssertTrue(winTest1, "There SHould be a win, something is wrong")

		let winTest2 = dm.testCheckingDown(row: 3, column: 1, gamePiece: .P2_SERVER)
		XCTAssertTrue(winTest2, "There SHould be a win, something is wrong")

	}



	/**
	Test Game no Win left to right
	*/
	func testGameDataManager_NoWinningGameLeftRight_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = true

		winLost = dm.testCheckingLeftRight(row: 0, column: 0, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 0, column: 1, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 0, column: 2, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 1, column: 0, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 1, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 1, column: 2, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

	}


	/**
	Test Game  Win left to right
	*/
	func testGameDataManager_WinningGameLeftRight_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.testCheckingLeftRight(row: 0, column: 0, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 0, column: 1, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 0, column: 2, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 0, column: 3, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 1, column: 0, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 1, column: 1, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 1, column: 2, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingLeftRight(row: 1, column: 3, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

	}




	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_WinDiagonal1_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.PLAYER_1]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.testCheckingDiagonal1(row: 0, column: 0, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 1, column: 1, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 2, column: 2, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 3, column: 3, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")


	}


	/**
	Test Game no win Diagonal 1 player 2
	*/
	func testDataManager_WinDiagonal1_2() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.P2_SERVER]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.testCheckingDiagonal1(row: 0, column: 0, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 1, column: 1, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 2, column: 2, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 3, column: 3, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

	}




	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_NoWinDiagonal1_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.testCheckingDiagonal1(row: 0, column: 0, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 1, column: 1, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 2, column: 2, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")


	}


	/**
	Test Game no win Diagonal 1 player 2
	*/
	func testDataManager_NoWinDiagonal1_2() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.testCheckingDiagonal1(row: 0, column: 0, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 1, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal1(row: 2, column: 2, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")


	}



	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_WinDiagonal2_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.PLAYER_1],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.testCheckingDiagonal2(row: 0, column: 3, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 1, column: 2, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 2, column: 1, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 3, column: 0, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

	}


	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_WinDiagonal2_2() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.P2_SERVER],
			[GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.testCheckingDiagonal2(row: 0, column: 3, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 1, column: 2, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 2, column: 1, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 3, column: 0, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

	}



	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_NoWinDiagonal2_1() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.EMPTY, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.EMPTY, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.testCheckingDiagonal2(row: 0, column: 3, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 1, column: 2, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 2, column: 1, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")


	}


	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_NoWinDiagonal2_2() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.EMPTY, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.testCheckingDiagonal2(row: 0, column: 3, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 1, column: 2, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.testCheckingDiagonal2(row: 2, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")


	}







	/**
	Test Game Win Down
	*/
	func testGameDataManager_WinningGameDown_1_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 	GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		let winTest1 = dm.isWinningMoveFrom(row: 3, column: 0, gamePiece: .PLAYER_1)
		XCTAssertTrue(winTest1, "There SHould be a win, something is wrong")

		let winTest2 = dm.isWinningMoveFrom(row: 3, column: 1, gamePiece: .P2_SERVER)
		XCTAssertTrue(winTest2, "There SHould be a win, something is wrong")

	}



	/**
	Test Game no Win left to right
	*/
	func testGameDataManager_NoWinningGameLeftRight_1_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = true

		winLost = dm.isWinningMoveFrom(row: 0, column: 0, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 0, column: 1, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 0, column: 2, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 0, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 2, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be No Win, something is wrong")

	}


	/**
	Test Game  Win left to right
	*/
	func testGameDataManager_WinningGameLeftRight_1_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.isWinningMoveFrom(row: 0, column: 0, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 0, column: 1, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 0, column: 2, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 0, column: 3, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 0, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 1, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 2, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 3, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

	}




	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_WinDiagonal1_1_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.PLAYER_1]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.isWinningMoveFrom(row: 0, column: 0, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 1, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 2, column: 2, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 3, column: 3, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")


	}


	/**
	Test Game no win Diagonal 1 player 2
	*/
	func testDataManager_WinDiagonal1_2_0_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.P2_SERVER]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.isWinningMoveFrom(row: 0, column: 0, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 1, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 2, column: 2, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 3, column: 3, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

	}




	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_NoWinDiagonal1_1_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.isWinningMoveFrom(row: 0, column: 0, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 1, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 2, column: 2, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")


	}


	/**
	Test Game no win Diagonal 1 player 2
	*/
	func testDataManager_NoWinDiagonal1_2_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.isWinningMoveFrom(row: 0, column: 0, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 2, column: 2, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")


	}



	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_WinDiagonal2_1_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.PLAYER_1],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.isWinningMoveFrom(row: 0, column: 3, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 2, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 2, column: 1, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 3, column: 0, gamePiece: .PLAYER_1)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

	}


	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_WinDiagonal2_2_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.P2_SERVER],
			[GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.isWinningMoveFrom(row: 0, column: 3, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 2, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 2, column: 1, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 3, column: 0, gamePiece: .P2_SERVER)
		XCTAssertTrue(winLost, "There should be a Win, something is wrong")

	}



	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_NoWinDiagonal2_1_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.EMPTY, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.EMPTY, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.isWinningMoveFrom(row: 0, column: 3, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 2, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 2, column: 1, gamePiece: .PLAYER_1)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")


	}


	/**
	Test Game no win Diagonal 1 player 1
	*/
	func testDataManager_NoWinDiagonal2_2_0() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.EMPTY, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.EMPTY, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 	GamePiece.P2_SERVER, 	GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		dm.testInjectGameUIData(targetData1)

		let data = dm.testGetGameUIData()
		print(dm)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		var winLost = false

		winLost = dm.isWinningMoveFrom(row: 0, column: 3, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 1, column: 2, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")

		winLost = dm.isWinningMoveFrom(row: 2, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(winLost, "There should be a Win, something is wrong")


	}



	/**
	Test for draw game
	*/
	func testDataManager_14() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.P2_SERVER, 	GamePiece.PLAYER_1, 	GamePiece.PLAYER_1, 	GamePiece.P2_SERVER],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER,	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1],
			[GamePiece.PLAYER_1, 	GamePiece.P2_SERVER, 	GamePiece.P2_SERVER, 	GamePiece.PLAYER_1]
		]

		let mockNetworkData = [0, 1, 3, 2,
							   1, 0, 2, 3,
							   0, 1, 3, 2,
							   0, 1, 3, 2]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let data = dm.testGetGameUIData()
		print(data)
		XCTAssertTrue(data == targetData1, "\(data) != \(targetData1)")

		print(dm)

		var result = true

		// Row 1
		result = dm.isWinningMoveFrom(row: 0, column: 0, gamePiece: .PLAYER_1)
		XCTAssertFalse(result, "No Win should be possible at 0,0")

		result = dm.isWinningMoveFrom(row: 0, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(result, "No Win should be possible at 0,1")

		result = dm.isWinningMoveFrom(row: 0, column: 2, gamePiece: .P2_SERVER)
		XCTAssertFalse(result, "No Win should be possible at 0,2")

		result = dm.isWinningMoveFrom(row: 0, column: 3, gamePiece: .PLAYER_1)
		XCTAssertFalse(result, "No Win should be possible at 0,3")


		// Row 2
		result = dm.isWinningMoveFrom(row: 1, column: 0, gamePiece: .P2_SERVER)
		XCTAssertFalse(result, "No Win should be possible at 1,0")

		result = dm.isWinningMoveFrom(row: 1, column: 1, gamePiece: .PLAYER_1)
		XCTAssertFalse(result, "No Win should be possible at 1,1")

		result = dm.isWinningMoveFrom(row: 1, column: 2, gamePiece: .PLAYER_1)
		XCTAssertFalse(result, "No Win should be possible at 1,2")

		result = dm.isWinningMoveFrom(row: 1, column: 3, gamePiece: .P2_SERVER)
		XCTAssertFalse(result, "No Win should be possible at 1,3")


		// Row 3
		result = dm.isWinningMoveFrom(row: 2, column: 0, gamePiece: .PLAYER_1)
		XCTAssertFalse(result, "No Win should be possible at 2,0")

		result = dm.isWinningMoveFrom(row: 2, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(result, "No Win should be possible at 2,1")

		result = dm.isWinningMoveFrom(row: 2, column: 2, gamePiece: .P2_SERVER)
		XCTAssertFalse(result, "No Win should be possible at 2,2")

		result = dm.isWinningMoveFrom(row: 2, column: 3, gamePiece: .PLAYER_1)
		XCTAssertFalse(result, "No Win should be possible at 2,3")


		// Row 4
		result = dm.isWinningMoveFrom(row: 3, column: 0, gamePiece: .PLAYER_1)
		XCTAssertFalse(result, "No Win should be possible at 3,0")

		result = dm.isWinningMoveFrom(row: 3, column: 1, gamePiece: .P2_SERVER)
		XCTAssertFalse(result, "No Win should be possible at 33,1")

		result = dm.isWinningMoveFrom(row: 3, column: 2, gamePiece: .P2_SERVER)
		XCTAssertFalse(result, "No Win should be possible at 3,2")

		result = dm.isWinningMoveFrom(row: 3, column: 3, gamePiece: .PLAYER_1)
		XCTAssertFalse(result, "No Win should be possible at 3,3")


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
			0, 1, 2, 3
		]

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let movesLeft = dm.areAnyPossibleMovesLeft

		XCTAssertFalse(movesLeft, "there should NOT be any moves left.")

	}

	/**
	Any moves Left?
	*/
	func testDataManager_16() {
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
	func testDataManager_17() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		let mockNetworkData = [Int]()

		dm.updateGameUIDataWithNetworkData(mockNetworkData)

		let movesLeft = dm.areAnyPossibleMovesLeft

		XCTAssertTrue(movesLeft, "there are many moves left.")

	}




}
