//
//  Networking.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import Foundation


protocol NetworkingDelagate {
	func reportTheReturnedMoves(_ moves: [Int])
}


/**
I have to admin, this isn't the best networking, but the return data from the server isn't exactly standard.
*/
class Networking {

	// MARK: - Properties

	let defaultSession = URLSession(configuration: .default)
	var dataTask: URLSessionDataTask?
	let baseURLString = "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production?moves="

	// MARK: - Inits (None)


	// MARK: - Class Methods

	/**
	Helper to Convert Moves
	*/
	private func convertToStringTheMoves(_ moves: [Int]) -> String {
		guard !moves.isEmpty else { return "[]" }
		guard moves.count > 1 else { return "[\(moves[0])]" }
		var results = "[\(String(moves[0]))"
		for moveIndex in 1..<moves.count {
			results += ",\(String(moves[moveIndex]))"
		}
		results += "]"
		return results
	}


	/**
	Helper to Convert Moves
	*/
	private func convertToMovesTheString(_ intArrayString: String) -> [Int] {

		var localString = intArrayString

		guard let leftBracIndex = localString.firstIndex(of: "[") else { return [Int]() }
		localString.remove(at: leftBracIndex)

		guard let rightBracIndex = localString.firstIndex(of: "]")else { return [Int]() }
		localString.remove(at: rightBracIndex)

		let splits = localString.split(separator: ",")

		var results = [Int]()

		for element in splits {
			if let theInt = Int(element) {
				results.append(theInt)
			}
		}

		return results

	}



	/**

	*/
	func pingServerWithMoves(_ moves: [Int], completion: @escaping (String) -> String) {

		guard var theDataTask = dataTask else { return }

		let movesAsString = convertToStringTheMoves(moves)

		let theURLString = "\(baseURLString)\(movesAsString)"

		theDataTask.cancel()
		if let theUrl = URL(string: theURLString) {
			theDataTask = defaultSession.dataTask(with: theUrl) { [weak self] data, response, error in

				defer {
					self?.dataTask = nil
				}
				if let theError = error {
					print("theError: \(theError)")
				} else if
					let theData = data {

					let stringInt = String(decoding: theData, as: UTF8.self)
					print("stringInt: \(stringInt)")

					let results = completion(stringInt)
					print("results: \(results)")

				}
			}
			theDataTask.resume()
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
