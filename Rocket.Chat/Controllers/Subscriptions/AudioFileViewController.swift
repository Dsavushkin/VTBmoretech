//
//  AudioFileViewController.swift
//  Rocket.Chat
//
//  Created by Filipe Alvarenga on 02/05/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

class AudioFileViewController: BaseViewController {

    @IBOutlet weak var audioPlayerContainer: UIView!
    @IBOutlet weak var audioTitle: UILabel!
    @IBOutlet weak var audioImage: UIImageView!

    var file: File!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioTitle.text = file.name
        navigationItem.title = file.uploadedAt?.formatted()

        setupAudioPlayer()
    }

    func setupAudioPlayer() {
        guard let view = ChatMessageAudioView.instantiateFromNib() else { return }
        view.file = file
        view.timeLabel.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        audioPlayerContainer.addSubview(view)
        view.topAnchor.constraint(equalTo: audioPlayerContainer.topAnchor, constant: -30).isActive = true
        view.leadingAnchor.constraint(equalTo: audioPlayerContainer.leadingAnchor, constant: 15).isActive = true
        view.trailingAnchor.constraint(equalTo: audioPlayerContainer.trailingAnchor, constant: -15).isActive = true
        view.bottomAnchor.constraint(equalTo: audioPlayerContainer.bottomAnchor, constant: 0).isActive = true
    }
}

// MARK: Themeable

extension AudioFileViewController {
    override func applyTheme() {
        super.applyTheme()
        guard let theme = view.theme else { return }

        view.backgroundColor = theme.auxiliaryBackground
        audioImage.tintColor = theme.titleText
    }
}
