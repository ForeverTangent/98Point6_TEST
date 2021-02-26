import UIKit

var str = "Hello, playground"

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let n86Moves = try N86Moves(json)
import Foundation

public typealias N86Moves = [Int]

public extension Array where Element == N86Moves.Element {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(N86Moves.self, from: data)
	}

	init(_ json: String, using encoding: String.Encoding = .utf8) throws {
		guard let data = json.data(using: encoding) else {
			throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
		}
		try self.init(data: data)
	}

	init(fromURL url: URL) throws {
		try self.init(data: try Data(contentsOf: url))
	}

	func jsonData() throws -> Data {
		return try newJSONEncoder().encode(self)
	}

	func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
		return String(data: try self.jsonData(), encoding: encoding)
	}
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
	let decoder = JSONDecoder()
	if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
		decoder.dateDecodingStrategy = .iso8601
	}
	return decoder
}

func newJSONEncoder() -> JSONEncoder {
	let encoder = JSONEncoder()
	if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
		encoder.dateEncodingStrategy = .iso8601
	}
	return encoder
}

// MARK: - URLSession response handlers

public extension URLSession {
	fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		return self.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else {
				completionHandler(nil, response, error)
				return
			}
			completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
		}
	}

	func n86MovesTask(with url: URL, completionHandler: @escaping (N86Moves?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		return self.codableTask(with: url, completionHandler: completionHandler)
	}
}






class Networking {
	let defaultSession = URLSession(configuration: .default)
	var dataTask: URLSessionDataTask?
	let baseURLString = "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production?moves="

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

	*/
	func pingServerWithMoves(_ moves: [Int]) {

		var theResults = ""

		let movesAsString = convertToStringTheMoves(moves)

		let theURLString = "\(baseURLString)\(movesAsString)"

		dataTask?.cancel()
		if let theUrl = URL(string: theURLString) {
			dataTask = defaultSession.dataTask(with: theUrl) { [weak self] data, response, error in
				defer {
					self?.dataTask = nil
				}
				if let theError = error {
					print("theError: \(theError)")
				} else if
					let theData = data {

					let stringInt = String(decoding: theData, as: UTF8.self)
					print("stringInt: \(stringInt)")


				}
			}
			dataTask?.resume()
		}


	}

}


extension Networking {

	#if DEBUG

	public func testConvertToStringTheMoves(_ moves: [Int]) -> String {
		return convertToStringTheMoves(moves)
	}

	#endif


}




Networking().pingServerWithMoves([])

