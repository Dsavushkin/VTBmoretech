//
//  ShowMoreSeparatorTableViewCell.swift
//  Rocket.Chat
//
//  Created by Filipe Alvarenga on 06/06/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

final class ShowMoreSeparatorTableViewCell: UITableViewCell {

    static let rowHeight: CGFloat = 76.0

    @IBOutlet weak var showMoreButton: UIButton!

    var showOrHideLoginServices: (() -> Void)?

    @IBAction func showMoreButtonDidPressed() {
        showOrHideLoginServices?()
    }

}

extension ShowMoreSeparatorTableViewCell {
    override func applyTheme() { }
}
