//
//  ViewController.swift
//  Tic-Tac-Toe
//
//  Created by Ammar.M on 3/3/20.
//  Copyright © 2020 Ammar.M. All rights reserved.
//

import SwiftEntryKit

enum Player {
    case one // X 1
    case two  // O 2
}

private enum ThumbDesc: String {
    case bottomToast = "ic_bottom_toast"
    case bottomFloat = "ic_bottom_float"
    case topToast = "ic_top_toast"
    case topFloat = "ic_top_float"
    case statusBarNote = "ic_sb_note"
    case topNote = "ic_top_note"
    case bottomPopup = "ic_bottom_popup"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var swiftyLabel: UILabel!
    @IBOutlet var squareViews: [UIView]!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet private var gameBoardButtons: [UIButton]!

    var currentPlayer: Player = .one
    var gameBoardState = [0, 0, 0,
                          0, 0, 0,
                          0, 0, 0]
    
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                               [0, 3, 6], [1, 4, 7], [2, 5, 8],
                               [0, 4, 8], [2, 4, 6]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction private func plays(_ sunder: UIButton) {
        currentPlayerPlay(sunder)
        updateGameBoardState(sunder)
        checkForWinner()
    }
    @IBAction func restart(_ sender: Any) {
        reset()
    }
    
    private func setupView() {
        swiftyLabel.text = "S \n w \n i \n t \n y"
        for view in squareViews {
            view.layer.cornerRadius = 10
        }
        for button in gameBoardButtons {
            button.layer.cornerRadius = 10
        }
        restartBtn.layer.cornerRadius = 20
    }
    
    private func checkForWinner() {
        for combination in winningCombinations {
            if gameBoardState[combination[0]] != 0 && gameBoardState[combination[0]] == gameBoardState[combination[1]] && gameBoardState[combination[1]] == gameBoardState[combination[2]] {
                print(combination)
                if gameBoardState[combination[0]] == 1 {
                    showLightAwesomePopupMessage("Congrats 🤪","Player X Winning 🥳")
                    reset()
                    return
                } else if gameBoardState[combination[0]] == 2 {
                    showLightAwesomePopupMessage("Congrats 🤪","Player O Winning 🥳")
                    reset()
                    return
                }
            }
        }
        if !(gameBoardState.contains(0)) {
            showLightAwesomePopupMessage("Oops 😔","You are Drow")
            reset()

        }
    }
    
    private func updateGameBoardState(_ sunder: UIButton) {
        let currnetPlayerButtonIndex = sunder.tag
        gameBoardState[currnetPlayerButtonIndex] = sunder.title(for: .normal) == "X" ? 1 : 2
    }
    private func currentPlayerPlay(_ sunder: UIButton) {
        sunder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40.0)
        switch currentPlayer {
        case .one:
            sunder.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0.5921568627, blue: 0.3568627451, alpha: 1)
            sunder.setTitle("X", for: .normal)
            sunder.setTitleColor(.black, for: .normal)
            currentPlayer = .two
        case .two:
            sunder.backgroundColor = #colorLiteral(red: 0.9241605997, green: 0.7914723158, blue: 0.5839835405, alpha: 1)
            sunder.setTitle("O", for: .normal)
            sunder.setTitleColor(.red, for: .normal)
            currentPlayer = .one
        }
        
        sunder.isEnabled = false
    }
    
    private func reset() {
        for button in gameBoardButtons {
            button.setTitle("", for: .normal)
            button.isEnabled = true
            button.backgroundColor = .clear
        }
        
        gameBoardState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        currentPlayer = .one
    }
    
    
    
    private func showLightAwesomePopupMessage(_ title: String, _ message: String) {
        var attributes = EKAttributes.centerFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(
            gradient: .init(
                colors: [EKColor(rgb: 0xfffbd5), EKColor(rgb: 0x966507)],
                startPoint: .zero,
                endPoint: CGPoint(x: 1, y: 1)
            )
        )
        attributes.screenBackground = .color(color: .dimmedDarkBackground)
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.roundCorners = .all(radius: 8)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 0.7, initialVelocity: 0)
            ),
            scale: .init(
                from: 0.7,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.35)
            )
        )
        attributes.positionConstraints.size = .init(
            width: .offset(value: 20),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.minEdge),
            height: .intrinsic
        )
        attributes.statusBar = .dark
        let image = UIImage(named: "ic_done_all_light_48pt")!.withRenderingMode(.alwaysTemplate)
        showPopupMessage(attributes: attributes,
                         title: title,
                         titleColor: .white,
                         description: message,
                         descriptionColor: .white,
                         buttonTitleColor: .black,
                         buttonBackgroundColor: .white,
                         image: image)
    }
    
    private func showPopupMessage(attributes: EKAttributes,
                                  title: String,
                                  titleColor: EKColor,
                                  description: String,
                                  descriptionColor: EKColor,
                                  buttonTitleColor: EKColor,
                                  buttonBackgroundColor: EKColor,
                                  image: UIImage? = nil) {
        
        var themeImage: EKPopUpMessage.ThemeImage?
        
        if let image = image {
            themeImage = EKPopUpMessage.ThemeImage(
                image: EKProperty.ImageContent(
                    image: image,
                    size: CGSize(width: 60, height: 60),
                    tint: titleColor,
                    contentMode: .scaleAspectFit
                )
            )
        }
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: UIFont.systemFont(ofSize: 20, weight: .medium),
                color: titleColor,
                alignment: .center,
                displayMode: .light
            )
        )
        let description = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: UIFont.systemFont(ofSize: 16, weight: .light),
                color: descriptionColor,
                alignment: .center,
                displayMode: .light
            )
        )
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "Got it!",
                style: .init(
                    font: UIFont.systemFont(ofSize: 16, weight: .bold),
                    color: buttonTitleColor,
                    displayMode: .light
                )
            ),
            backgroundColor: buttonBackgroundColor,
            highlightedBackgroundColor: buttonTitleColor.with(alpha: 0.05),
            displayMode: .light
        )
        let message = EKPopUpMessage(
            themeImage: themeImage,
            title: title,
            description: description,
            button: button) {
                SwiftEntryKit.dismiss()
        }
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

