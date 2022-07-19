//
//  BlockOfWordsView.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 01.04.2022.
//


import UIKit

final class BlockOfWordsView: UIView {
    var finalLayout: FinalLayout?
    var viewModel: ViewModel! {
        didSet {
            guard viewModel != oldValue else {return}
            finalLayout = nil
            numberOfNewLabel.text = viewModel.numberOfNewText
            numberOfMistakesLabel.text = viewModel.numberOfMistakesText
            numberOfOldLabel.text = viewModel.numberOfOldText
            titleOfBlockLabel.text = viewModel.titleText
            setNeedsLayout()
        }
    }
    
    private var numberOfNewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = kBlueColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var numberOfMistakesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = kRedColor
        label.textAlignment = .center
        label.numberOfLines = 0
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
    
    var titleOfBlockLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
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
        titleOfBlockLabel.frame = finalLayout.titleOfBlockLabelFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BlockOfWordsView {
    private func setupView() {
        backgroundColor = .white
        
        addSubviews([
            numberOfNewLabel,
            numberOfOldLabel,
            numberOfMistakesLabel,
            titleOfBlockLabel
        ])
        layer.cornerRadius = 12
    }
}

extension BlockOfWordsView {
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
            
            let titleOfBlockLabelFrame = CGRect(x: widthOfCard - 50,
                                                y: (numberOfOldLabelFrame.maxY + padding) / 2 - 15,
                                                width: 30,
                                                height: 30)
            
            return FinalLayout(
                numberOfNewLabelFrame: numberOfNewLabelFrame,
                numberOfMistakesLabelFrame: numberOfMistakesLabelFrame,
                numberOfOldLabelFrame: numberOfOldLabelFrame,
                titleOfBlockLabelFrame: titleOfBlockLabelFrame,
                padding: padding
            )
        }
    }
    
    struct FinalLayout {
        let numberOfNewLabelFrame: CGRect
        let numberOfMistakesLabelFrame: CGRect
        let numberOfOldLabelFrame: CGRect
        let titleOfBlockLabelFrame: CGRect
        let padding: CGFloat
        var cardHeight: CGFloat {
            numberOfOldLabelFrame.maxY + padding
        }
    }
}

extension BlockOfWordsView {
    struct ViewModel: Equatable {
        var numberOfNewText: String
        var numberOfOldText: String
        var numberOfMistakesText: String
        var titleText: String
    }
}

