//
//  _98Point6_Networking_Tests.swift
//  98Point6_TESTTests
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import XCTest
@testable import _8Point6_TEST

class _98Point6_Networking_Tests: XCTestCase {
	/**
	Testing Insert Piece
	*/
	func testNetworking_ConvertMoves_1() {
		let networking = Networking()

		var moves = [Int]()
		var targetString = "[]"
		var resultString = networking.testConvertToStringTheMoves(moves)
		XCTAssert(type(of:resultString) == String.self, "\(type(of:resultString)) == \(String.self)")
		print(resultString)
		XCTAssert(resultString == targetString, "\(resultString) != \(targetString)")

		moves = [1]
		targetString = "[1]"
		resultString = networking.testConvertToStringTheMoves(moves)
		XCTAssert(type(of:resultString) == String.self, "\(type(of:resultString)) == \(String.self)")
		print(resultString)
		XCTAssert(resultString == targetString, "\(resultString) != \(targetString)")

		moves = [1,2]
		targetString = "[1,2]"
		resultString = networking.testConvertToStringTheMoves(moves)
		XCTAssert(type(of:resultString) == String.self, "\(type(of:resultString)) == \(String.self)")
		print(resultString)
		XCTAssert(resultString == targetString, "\(resultString) != \(targetString)")

	}


	func testNetworking_ConvertString_1() {
		let networking = Networking()

		var string = "[]"
		var targetArray = [Int]()
		var results = networking.testConvertToMovesTheString(string)
		XCTAssert(type(of:results) == [Int].self, "\(type(of:results)) == \([Int].self)")
		print(results)
		XCTAssert(results == targetArray, "\(results) != \(targetArray)")

		string = "[1]"
		targetArray = [1]
		results = networking.testConvertToMovesTheString(string)
		XCTAssert(type(of:results) == [Int].self, "\(type(of:results)) == \([Int].self)")
		print(results)
		XCTAssert(results == targetArray, "\(results) != \(targetArray)")

		string = "[1,2]"
		targetArray = [1,2]
		results = networking.testConvertToMovesTheString(string)
		XCTAssert(type(of:results) == [Int].self, "\(type(of:results)) == \([Int].self)")
		print(results)
		XCTAssert(results == targetArray, "\(results) != \(targetArray)")

	}




	/**
	Testing Insert Piece
	*/
	func testNetworking_PingServer_1() {
		let networking = Networking()

		let moves = [0,1,2,3,0,1,2,3,0,1,2,3,0,1,2]

		let target = [0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]

		print("GET")

		var waitingForReturn = false

		networking.getNewMovesWithMoves(moves) { (result) in
			print("HEY")
			print(result)

			switch result {
				case .SUCCESS(let theData):
					print("theData \(theData)")
					XCTAssertTrue(theData == target, "\(theData) == \(target)")
				case .NO_MORE_MOVES:
					print("No More Moves")
					XCTAssertFalse(false, "This should not happen")
				case .FAILURE(let theError):
					XCTAssertTrue(false, "\(theError)")
			}

			waitingForReturn = true
		}

		while !waitingForReturn {

		}

	}


	/**
	Testing Insert Piece
	*/
	func testNetworking_PingServer_2() {
		let networking = Networking()

		let moves = [0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]

		print("GET")

		var waitingForReturn = false

		networking.getNewMovesWithMoves(moves) { (result) in
			print("HEY")
			print(result)

			switch result {
				case .SUCCESS(let theData):
					print("theData \(theData)")
					XCTAssertTrue(false, "We should not have gotten data back.")
				case .NO_MORE_MOVES:
					print("No More Moves")
					XCTAssertTrue(true)
				case .FAILURE(let theError):
					XCTAssertTrue(false, "\(theError)")
			}

			waitingForReturn = true
		}

		while !waitingForReturn {

		}

	}


	/**
	Testing Insert Piece
	*/
	func testNetworking_PingServer_3() {
		let networking = Networking()

		let moves = [Int]()

		print("GET")

		var waitingForReturn = false

		networking.getNewMovesWithMoves(moves) { (result) in
			print("HEY")
			print(result)

			switch result {
				case .SUCCESS(let theData):
					print("theData \(theData)")
					XCTAssertTrue(theData.count == 1, "\(theData.count) != 1")
				case .NO_MORE_MOVES:
					print("No More Moves")
					XCTAssertFalse(false, "This should not happen")
				case .FAILURE(let theError):
					XCTAssertTrue(false, "\(theError)")
			}

			waitingForReturn = true
		}

		while !waitingForReturn {

		}

	}


	

}
