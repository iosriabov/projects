//
//  StatusView.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import UIKit

final class StatusView: UIView {
    var finalLayout: FinalLayout?
    var viewModel: ViewModel! {
        didSet {
            guard viewModel != oldValue else {return}
            finalLayout = nil
            numberOfNewLabel.text = viewModel.numberOfNewText
            numberOfMistakesLabel.text = viewModel.numberOfMistakesText
            numberOfOldLabel.text = viewModel.numberOfOldText
            setNeedsLayout()
        }
    }
    
    private var numberOfNewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = kBlueColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var numberOfMistakesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = kRedColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var numberOfOldLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = kGreenColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        button.backgroundColor = kBlueColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var secondsRemainingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = kBlueColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "play.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = kBlueColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let viewModel = viewModel else { return }
        let builder = LayoutBuilder(widthOfCard: frame.width,
                                    viewModel: viewModel)
        let finalLayout = builder.calculateLayout()
        numberOfNewLabel.frame = finalLayout.numberOfNewLabelFrame
        numberOfOldLabel.frame = finalLayout.numberOfOldLabelFrame
        numberOfMistakesLabel.frame = finalLayout.numberOfMistakesLabelFrame
        moreButton.frame = finalLayout.buttonMoreFrame
        secondsRemainingLabel.frame = finalLayout.secondsRemainingLabelFrame
        playButton.frame = finalLayout.playButtonFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatusView {
    private func setupView() {
        backgroundColor = .white
        addSubviews([
            numberOfNewLabel,
            numberOfOldLabel,
            numberOfMistakesLabel,
            moreButton,
            secondsRemainingLabel,
            playButton
        ])
        layer.cornerRadius = 12
    }
}

extension StatusView {
    struct LayoutBuilder {
        let widthOfCard: CGFloat
        let viewModel: ViewModel
        func calculateLayout() -> FinalLayout {
            let padding: CGFloat = 20
            
            let numberOfNewLabelHeight = viewModel
                .numberOfNewText
                .height(
                    withWidth: widthOfCard - padding * 2,
                    font: .systemFont(ofSize: 17))
            
            let numberOfMistakesLabelHeight = viewModel
                .numberOfMistakesText
                .height(
                    withWidth: widthOfCard - padding * 2,
                    font: .systemFont(ofSize: 17))
            
            let numberOfOldLabelHeight = viewModel
                .numberOfOldText
                .height(
                    withWidth: widthOfCard - padding * 2,
                    font: .systemFont(ofSize: 17))
            
            
            let numberOfNewLabelFrame = CGRect(x: padding,
                                               y: padding,
                                               width: 40,
                                               height: numberOfNewLabelHeight)
            
            let numberOfMistakesLabelFrame = CGRect(x: numberOfNewLabelFrame.maxX + 10,
                                                    y: padding,
                                                    width: 30,
                                                    height: numberOfMistakesLabelHeight)
            
            let numberOfOldLabelFrame = CGRect(x: numberOfMistakesLabelFrame.maxX + 10,
                                               y: padding,
                                               width: 40,
                                               height: numberOfOldLabelHeight)
            
            
            let buttonMoreFrame = CGRect(x: widthOfCard - 50,
                                         y: (numberOfOldLabelFrame.maxY + padding) / 2 - 15,
                                         width: 30,
                                         height: 30)
            
            let playButtonFrame = CGRect(x: buttonMoreFrame.minX - 10 - 30 ,
                                         y: (numberOfOldLabelFrame.maxY + padding) / 2 - 15,
                                         width: 30,
                                         height: 30)
            let secondsRemainingLabelFrame = CGRect(x: playButtonFrame.minX - 10 - 30,
                                                    y: (numberOfOldLabelFrame.maxY + padding) / 2 - 15,
                                                    width: 30,
                                                    height: 30)
            
            return FinalLayout(
                numberOfNewLabelFrame: numberOfNewLabelFrame,
                numberOfMistakesLabelFrame: numberOfMistakesLabelFrame,
                numberOfOldLabelFrame: numberOfOldLabelFrame,
                buttonMoreFrame: buttonMoreFrame,
                playButtonFrame: playButtonFrame,
                secondsRemainingLabelFrame: secondsRemainingLabelFrame,
                padding: padding
            )
        }
    }
    
    struct FinalLayout {
        let numberOfNewLabelFrame: CGRect
        let numberOfMistakesLabelFrame: CGRect
        let numberOfOldLabelFrame: CGRect
        let buttonMoreFrame: CGRect
        let playButtonFrame: CGRect
        let secondsRemainingLabelFrame: CGRect
        let padding: CGFloat
        var cardHeight: CGFloat {
            numberOfOldLabelFrame.maxY + padding
        }
    }
}

extension StatusView {
    struct ViewModel: Equatable {
        var numberOfNewText: String
        var numberOfOldText: String
        var numberOfMistakesText: String
    }
}

