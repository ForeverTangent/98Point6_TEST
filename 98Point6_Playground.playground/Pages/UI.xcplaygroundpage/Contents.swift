//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport


enum GamePiece: Int {
	case EMPTY
	case PLAYER_1
	case PLAYER_2
}

extension GamePiece: CustomStringConvertible {
	var description: String {
		switch self {
			case .EMPTY:
				return "E"
			case .PLAYER_1:
				return "1"
			case .PLAYER_2:
				return "2"
		}
	}
}


//class TokenColumnView: UIView {
//
//	// MARK: - Properties
//
//	private var numberOfTokens: Int = 4
//	public var tokenViews = [TokenView]()
//	private var tokenSize: CGSize {
//		get {
//			return CGSize(width: frame.width / CGFloat(numberOfTokens),
//						  height: frame.height / CGFloat(numberOfTokens))
//		}
//	}
//
//	// MARK: - Inits
//
//	init(numberOfTokens: Int) {
//		self.numberOfTokens = numberOfTokens
//		super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 400))
//		commonInit()
//	}
//
//	required init?(coder: NSCoder) {
//		super.init(coder: coder)
//		commonInit()
//	}
//
//
//	private func commonInit() {
//		backgroundColor = .gray
//
////		let resultingView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 400))
////		resultingView.backgroundColor = .gray
//
//		let tokenFrameSize =  CGRect(x: 0,
//									 y: 0,
//									 width: 100,
//									 height: 100)
//		let firstToken = TokenView()
//		firstToken.currentPiece = .PLAYER_1
//		firstToken.frame = tokenFrameSize
//
//		let secondToken = TokenView(frame: tokenFrameSize)
//		secondToken.currentPiece = .EMPTY
//		secondToken.frame = tokenFrameSize
//
//		let thirdToken = TokenView(frame: tokenFrameSize)
//		thirdToken.currentPiece = .PLAYER_1
//		thirdToken.frame = tokenFrameSize
//
//		let fourthToken = TokenView(frame: tokenFrameSize)
//		fourthToken.currentPiece = .PLAYER_2
//		fourthToken.frame = tokenFrameSize
//
//		let columnView = UIStackView(arrangedSubviews: [
//			firstToken,
//			secondToken,
//			thirdToken,
//			fourthToken
//		])
//		columnView.axis = .vertical
//		columnView.distribution = .fillEqually
//		columnView.frame = bounds
//
//		columnView.accessibilityLabel = ""
//
//		addSubview(columnView)
//
//	}
//
//	// MARK: - Class Methods
//}





class TokenView: UIImageView {

	let blueImage = UIImage(named: "BLUE_TOKEN.pdf")
	let redImage = UIImage(named: "RED_TOKEN.pdf")
	let emptyImage = UIImage(named: "EMPTY_TOKEN.pdf")

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
				case .PLAYER_2:
					self.image = blueImage
					self.accessibilityLabel = "BLUE"
					self.setNeedsDisplay()
			}
		}
	}

}



class ViewController : UIViewController {

	// MARK: - Properties


	override func loadView() {

		// UI

		let view = UIView()
		view.backgroundColor = .white

		let column = createColumn()

//		let column = TokenColumnView(numberOfTokens: 4)
		column.frame = CGRect(x: 0, y: 0, width: 100, height: 400)

		view.addSubview(column)

		self.view = view

		let asdf = column.subviews[0] as! UIStackView
		asdf.arrangedSubviews[0].removeFromSuperview()

//		qwer.currentPiece = .PLAYER_1



	}


	func createColumn(withNumberOfRows numberOfRows: Int = 4) -> UIView {

		let resultingView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 400))
		resultingView.backgroundColor = .gray

		let tokenFrameSize =  CGRect(x: 0,
									 y: 0,
									 width: 100,
									 height: 100)
		let firstToken = TokenView()
		firstToken.currentPiece = .PLAYER_1
		firstToken.frame = tokenFrameSize

		let secondToken = TokenView(frame: tokenFrameSize)
		secondToken.currentPiece = .EMPTY
		secondToken.frame = tokenFrameSize

		let thirdToken = TokenView(frame: tokenFrameSize)
		thirdToken.currentPiece = .PLAYER_1
		thirdToken.frame = tokenFrameSize

		let fourthToken = TokenView(frame: tokenFrameSize)
		fourthToken.currentPiece = .PLAYER_2
		fourthToken.frame = tokenFrameSize

		let columnView = UIStackView(arrangedSubviews: [
			firstToken,
			secondToken,
			thirdToken,
			fourthToken
		])
		columnView.axis = .vertical
		columnView.distribution = .fillEqually
		columnView.frame = resultingView.bounds

		columnView.accessibilityLabel = ""

		resultingView.addSubview(columnView)


		return resultingView

	}

	var rowOfStacks = UIStackView()

	var stackView = UIStackView()

	func configureStackView() {
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.topAnchor.constraint(equalTo: rowOfStacks.topAnchor, constant: 0.0).isActive = true


	}


	func createColumnsWith(gamePieces: [GamePiece]) -> UIView {

		let resultingView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 400))
		resultingView.backgroundColor = .gray

		let tokenFrameSize =  CGRect(x: 0,
									 y: 0,
									 width: 100,
									 height: 100)
		let firstToken = TokenView()
		firstToken.currentPiece = .PLAYER_1
		firstToken.frame = tokenFrameSize

		let secondToken = TokenView(frame: tokenFrameSize)
		secondToken.currentPiece = .EMPTY
		secondToken.frame = tokenFrameSize

		let thirdToken = TokenView(frame: tokenFrameSize)
		thirdToken.currentPiece = .PLAYER_1
		thirdToken.frame = tokenFrameSize

		let fourthToken = TokenView(frame: tokenFrameSize)
		fourthToken.currentPiece = .PLAYER_2
		fourthToken.frame = tokenFrameSize

		let columnView = UIStackView(arrangedSubviews: [
			firstToken,
			secondToken,
			thirdToken,
			fourthToken
		])
		columnView.axis = .vertical
		columnView.distribution = .fillEqually
		columnView.frame = resultingView.bounds

		columnView.accessibilityLabel = ""

		resultingView.addSubview(columnView)


		return resultingView

	}




}

PlaygroundPage.current.liveView = ViewController()

//: [Next](@next)
