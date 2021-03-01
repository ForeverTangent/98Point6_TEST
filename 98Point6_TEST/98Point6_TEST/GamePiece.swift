//
//  GamePiece.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import Foundation

enum GamePiece: Int {
	case EMPTY
	case PLAYER_1
	case P2_SERVER
}

extension GamePiece: CustomStringConvertible {
	var description: String {
		switch self {
			case .EMPTY:
				return "E"
			case .PLAYER_1:
				return "1"
			case .P2_SERVER:
				return "2"
		}
	}
}
