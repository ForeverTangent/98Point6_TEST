//
//  TokenView.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/28/21.
//

import UIKit

class TokenView: UIImageView {

	let blueImage = #imageLiteral(resourceName: "BLUE_TOKEN")
	let redImage = #imageLiteral(resourceName: "RED_TOKEN")
	let emptyImage = #imageLiteral(resourceName: "EMPTY_TOKEN")

	var currentPiece = GamePiece.EMPTY {
		didSet {
			switch currentPiece {
				case .EMPTY:
					self.image = emptyImage
					self.accessibilityLabel = ""
					self.setNeedsDisplay()
				case .PLAYER_1:
					self.image = redImage
					self.accessibilityLabel = "RED"
					self.setNeedsDisplay()
				case .P2_SERVER:
					self.image = blueImage
					self.accessibilityLabel = "BLUE"
					self.setNeedsDisplay()
			}
		}
	}

	init() {
		super.init(frame: CGRect.zero)
		self.isUserInteractionEnabled = false
		self.isAccessibilityElement = false
		self.accessibilityLabel = "TOKEN"

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
