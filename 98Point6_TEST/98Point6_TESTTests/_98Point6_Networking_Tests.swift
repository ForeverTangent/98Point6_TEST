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



//	/**
//	Testing Insert Piece
//	*/
//	func testNetworking_PingServer_1() {
//		let networking = Networking()
//
//		var moves = [Int]()
//
//		networking.pingServerWithMoves(moves)
//
//	}


}
