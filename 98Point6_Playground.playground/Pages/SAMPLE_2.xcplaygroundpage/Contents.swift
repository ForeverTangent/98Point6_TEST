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






class test {
	let defaultSession = URLSession(configuration: .default)
	var dataTask: URLSessionDataTask?
	//let theURL = URL(string:"https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production?moves=%5B0,1,2,3,0,1,2,3,0,1,2,3,0,1%5D")!

	func run() {
		// 1
		dataTask?.cancel()
		// 2
		if var urlComponents = URLComponents(string: "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production") {
			urlComponents.query = "moves=%5B0,1,2,3,0,1,2,3,0,1,2,3,0,1%5D"
			// 3
			guard let url = urlComponents.url else {
				return
			}
			// 4
			dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
				defer {
					self?.dataTask = nil
				}
				// 5
				if let theError = error {
					print("theError: \(theError)")
				} else if
					let theData = data {

					print("theData: \(theData)")

					let stringInt = String(decoding: theData, as: UTF8.self)

					print("stringInt: \(stringInt)")

					// 6

//					print("response: \(response)")
				}
			}
			// 7
			dataTask?.resume()
		}

	}
}


func run2() {
	if let url = URL(string: "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production?moves=%5B0,1,2,3,0,1,2,3,0,1,2,3,0,1,2%5D") {
		do {
			let contents = try String(contentsOf: url)
			print(contents)
		} catch {
			// contents could not be loaded
		}
	} else {
		// the URL was bad!
	}
}

func run3() {
	if let url = URL(string: "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production?moves=%5B0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3%5D") {
		do {
			let contents = try String(contentsOf: url)
			print(contents)
		} catch {
			// contents could not be loaded
			print(error)
		}
	} else {
		// the URL was bad!
	}
}


run2()
run3()
