//
//  SEComposeViewModel.swift
//  Rocket.Chat.ShareExtension
//
//  Created by Matheus Cardoso on 3/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

struct SEComposeViewModel {
    var cells: [SEComposeCellModel]
    var isEnabled: Bool
}

// MARK: DataSource

extension SEComposeViewModel {
    var numberOfSections: Int {
        return 1
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        switch section {
        case 0:
            return cells.count
        default:
            return 0
        }
    }

    func cellForItemAt(_ indexPath: IndexPath) -> SEComposeCellModel {
        return cells[indexPath.item]
    }
}

// MARK: State

extension SEComposeViewModel {
    init(state: SEState) {
        self.isEnabled = !state.isSubmittingContent
        self.cells = []
        self.cells = state.content.enumerated().reduce([SEComposeCellModel](), { total, current in
            switch current.element.type {
            case .text(let text):
                return total + [SEComposeTextCellModel(contentIndex: current.offset, text: text, isEnabled: self.isEnabled)]
            case .file(let file):
                return total + [SEComposeFileCellModel(contentIndex: current.offset, file: file, isEnabled: self.isEnabled)]
            }
        })
    }
}
