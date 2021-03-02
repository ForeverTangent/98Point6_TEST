//
//  Networking.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import Foundation


/**
Prossible logical results we get from talking to the server
*/
enum MoveReults<Value> {
	case SUCCESS(Value)
	case NO_MORE_MOVES
	case FAILURE(Error)
}



/**
I have to admit, this isn't the best networking, but gets the job done.
*/
class Networking {

	// MARK: - Properties

	let defaultSession = URLSession(configuration: .default)
	var dataTask: URLSessionDataTask?
	let baseURLString = "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production?moves="


	// MARK: - Class Methods

	/**
	Helper to Convert Moves

	Techincally this function is redundant but it helps me think through everything.
	- Parameter moves: [Int]
	- Returns: a String
	*/
	private func convertToStringTheMoves(_ moves: [Int]) -> String {
		guard let theString = try? moves.jsonString() else { return "" }
		return theString
	}


	/**
	Helper to Convert Moves

	Techincally this function is redundant but it helps me think through everything.
	- Parameter intArrayString: String
	- Returns: [Int]
	*/
	private func convertToMovesTheString(_ intArrayString: String) -> [Int] {
		guard let asdf = try? Array(intArrayString) else { return [Int]() }
		return asdf
	}


	/**
	Get the new moves from the server

	- Parameter moves: [Int], current moves list
	- Parameter completion: @escaping (MoveReults<[Int]>) -> Void
	*/
	func getNewMovesWithMoves(_ moves: [Int], completion: @escaping (MoveReults<[Int]>) -> Void) {

		let movesAsString = convertToStringTheMoves(moves)
		let theURLString = "\(baseURLString)\(movesAsString)"

		dataTask?.cancel()

		if let theUrl = URL(string: theURLString) {
			dataTask = defaultSession.dataTask(with: theUrl) { [weak self] data, response, error in
				guard let self = self else { return }
				defer {
					self.dataTask = nil
				}
				if let theError = error {
					print("theError: \(theError)")
					completion(.FAILURE(theError))
				} else if
					let theData = data {
					let stringInt = String(decoding: theData, as: UTF8.self)
					if stringInt.contains("No moves left") {
						completion(.NO_MORE_MOVES)
					}
					let intArray = self.convertToMovesTheString(stringInt)
					completion(.SUCCESS(intArray))
				}
			}

			dataTask?.resume()

		}

	}

}


// MARK: - Unit Testing

extension Networking {

	#if DEBUG

	public func testConvertToStringTheMoves(_ moves: [Int]) -> String {
		return convertToStringTheMoves(moves)
	}


	public func testConvertToMovesTheString(_ intArrayString: String) -> [Int] {
		return convertToMovesTheString(intArrayString)
	}

	#endif


}
