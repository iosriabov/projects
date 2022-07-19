//
//  ResultView.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import UIKit

final class GeneralInfoView: UIView {
    var finalLayout: FinalLayout?
    var viewModel: ViewModel! {
        didSet {
            guard viewModel != oldValue else {return}
            finalLayout = nil
            formulaLabel.text = viewModel.welcomeLabel
            newWordsLabel.text = viewModel.numberOfNewWords
            oldWordsLabel.text = viewModel.numberOfOldWords
            setNeedsLayout()
        }
    }
    
    private var formulaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private var newWordsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private var oldWordsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
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
        formulaLabel.frame = finalLayout.formulaLabelFrame
        oldWordsLabel.frame = finalLayout.sexLabelFrame
        newWordsLabel.frame = finalLayout.ageLabelFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GeneralInfoView {
    private func setupView() {
        backgroundColor = .white
        
        addSubviews([
            formulaLabel,
            oldWordsLabel,
            newWordsLabel
        ])
        layer.cornerRadius = 12
        
    }
}

extension GeneralInfoView {
    struct LayoutBuilder {
        let widthOfCard: CGFloat
        let viewModel: ViewModel
        func calculateLayout() -> FinalLayout {
            let padding: CGFloat = 20
            
            let dietLabelHeight = viewModel
                .welcomeLabel
                .height(
                    withWidth: widthOfCard - padding * 2,
                    font: .systemFont(ofSize: 17))
            
            let ageLabelHeight = viewModel
                .numberOfNewWords
                .height(
                    withWidth: widthOfCard - padding * 2,
                    font: .systemFont(ofSize: 15))
            
            let sexLabelHeight = viewModel
                .numberOfOldWords
                .height(
                    withWidth: widthOfCard - padding * 2,
                    font: .systemFont(ofSize: 15))
            
            
            let dietLabelFrame = CGRect(x: padding,
                                        y: padding,
                                        width: widthOfCard - padding * 2,
                                        height: dietLabelHeight)
            
            let ageLabelFrame = CGRect(x: padding,
                                       y: dietLabelFrame.maxY + padding / 5,
                                       width: dietLabelFrame.width,
                                       height: ageLabelHeight)
            
            let sexLabelFrame = CGRect(x: padding,
                                       y: ageLabelFrame.maxY + padding / 5,
                                       width: dietLabelFrame.width,
                                       height: sexLabelHeight)
            
            return FinalLayout(
                formulaLabelFrame: dietLabelFrame,
                ageLabelFrame: ageLabelFrame,
                sexLabelFrame: sexLabelFrame,
                padding: padding
            )
        }
    }
    
    struct FinalLayout {
        let formulaLabelFrame: CGRect
        let ageLabelFrame: CGRect
        let sexLabelFrame: CGRect
        let padding: CGFloat
        var cardHeight: CGFloat {
            sexLabelFrame.maxY + padding
        }
    }
}

extension GeneralInfoView {
    struct ViewModel: Equatable {
        var numberOfOldWords: String
        var numberOfNewWords: String
        var welcomeLabel: String
    }
}
