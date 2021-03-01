//
//  ColumnStackView.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/28/21.
//

import UIKit

class ColumnStackView: UIStackView {

	// MARK: - Properties

	public var columnNumber = 0
	public var cellViews = [UIView]()


	// MARK: - Class Methods

	public func updateCellInRow(_ row: Int, withGamePiece gamePiece: GamePiece) {
		let uiRowNumber = cellViews.count - row - 1
		let cell = arrangedSubviews[uiRowNumber] as! TokenView
		cell.currentPiece = gamePiece
		updateAccessiblityValues()
	}


	private func updateAccessiblityValues() {
		var results = ""
		for index in stride(from: cellViews.count-1, to: -1, by: -1) {
			let tokenCell = cellViews[index] as! TokenView
			if let theAccessibilityLabel = tokenCell.accessibilityLabel {
				results.append(theAccessibilityLabel)
				results.append(" , ")
			}
		}
		self.accessibilityValue = results
	}

}
