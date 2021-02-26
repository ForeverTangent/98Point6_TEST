//
//  ViewController.swift
//  98Point6_TEST
//
//  Created by Stanley Rosenbaum on 2/26/21.
//

import UIKit

class ViewController: UIViewController {

	// MARK: - Properties

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	// MARK: - Class Methods
}



extension ViewController: NetworkingDelagate {
	func reportTheReturnedMoves(_ moves: [Int]) {
	}
}
