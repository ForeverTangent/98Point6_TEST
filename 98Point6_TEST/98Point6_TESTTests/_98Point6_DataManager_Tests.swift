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

		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0))
		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0))
		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0))


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

		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0))
		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_2, intoColumn: 0))
		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0))


		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, GamePiece.EMPTY],
			[GamePiece.PLAYER_2, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY]
		]
		print(dm.gameUIData)
		XCTAssertTrue(dm.gameUIData == targetData1, "dm.gameUIData != targetData")

	}


	func testDataManager_1_3() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0))
		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_2, intoColumn: 0))
		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0))
		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_2, intoColumn: 0))

		XCTAssertFalse(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0),
					   "Added piece when we should not have been able too")
		XCTAssertFalse(dm.testInsertTokenForPlayer(.PLAYER_2, intoColumn: 0),
					   "Added piece when we should not have been able too")

		let targetData1 = [
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_2, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_1, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_2, 	GamePiece.EMPTY, 	GamePiece.EMPTY, 	GamePiece.EMPTY]
		]
		print(dm.gameUIData)
		XCTAssertTrue(dm.gameUIData == targetData1, "dm.gameUIData != targetData")

	}


	/**
	Test Get Column Data
	*/
	func testDataManager_2() {
		let dm = GameDataManager(numberOfColumns: 4, numberOfRows: 4)

		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0))
		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_2, intoColumn: 0))
		XCTAssertTrue(dm.testInsertTokenForPlayer(.PLAYER_1, intoColumn: 0))

		let targetData1 = [GamePiece.PLAYER_1, 	GamePiece.PLAYER_2, GamePiece.PLAYER_1, GamePiece.EMPTY]
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
			[GamePiece.PLAYER_1, 	GamePiece.PLAYER_2, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY],
			[GamePiece.PLAYER_2, 	GamePiece.PLAYER_1, 	GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.PLAYER_2, 	GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY],
			[GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY, 		GamePiece.EMPTY]
		]

		let data = dm.gameUIData
		print(data)
		XCTAssertTrue(data == targetData1, "data != targetData")

	}



	/**
	Insert from Network Data
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
	Insert from Network Data
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
	Insert from Network Data
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




}
