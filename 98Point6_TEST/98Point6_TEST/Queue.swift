//
//  SGDSQueue.swift
//  SGDS
//
//  Created by Stanley Rosenbaum on 10/20/20.
//

import Foundation

class Queue<E> {
	var items  = [E]()

	func push(_ item: E) {
		items.append(item)
	}

	func pop() -> E? {
		return items.removeFirst()
	}

	func peak() -> E? {
		return items.first
	}

	func count() -> Int {
		return items.count
	}

	var isEmpty: Bool {
		get {
			return items.isEmpty
		}
	}

	func clear() {
		items.removeAll()
	}

}



extension Queue: CustomStringConvertible {
	var description: String {
		get {
			var returnString = "TOP, "
			for element in items.reversed() {
				returnString.append("\(element), ")
			}
			returnString.append("BOTTOM")
			return returnString
		}
	}

	func printStack() {
		print(description)
	}

}
