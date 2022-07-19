//
//  CardView.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//


import UIKit

final class CardView: UIView {
    var finalLayout: FinalLayout?
    var viewModel: ViewModel! {
        didSet {
            guard viewModel != oldValue else {return}
            finalLayout = nil
            questionLabel.text = viewModel.secondSide
            answerLabel.text = viewModel.firstSide
            setNeedsLayout()
        }
    }
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var answerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var iKnowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Помню", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        button.backgroundColor = UIColor("#8AC926")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var iDontKnowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Повторить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        button.backgroundColor = UIColor("#FF595E")
        button.setTitleColor(.white, for: .normal)
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
        
        questionLabel.frame = finalLayout.questionLabelFrame
        iKnowButton.frame = finalLayout.iKnowButtonFrame
        iDontKnowButton.frame = finalLayout.iDontKnowButtonFrame
        answerLabel.frame = finalLayout.answerLabelFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CardView {
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        addSubviews([
            questionLabel,
            iKnowButton,
            iDontKnowButton,
            answerLabel
        ])
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
    }
}

extension CardView {
    struct LayoutBuilder {
        let widthOfCard: CGFloat
        let viewModel: ViewModel
        func calculateLayout() -> FinalLayout {
            let padding: CGFloat = 20
            
            var iDontKnowButtonHeight: CGFloat {
                viewModel.cardTapped ? widthOfCard / 5  : 0
                
            }
            var iDontKnowButtonWidth: CGFloat {
                widthOfCard / 2 - padding - 10
            }
            
            
            
            let questionLabelWidth = widthOfCard - padding * 2
            
            var questionLabelHeight: CGFloat {
                viewModel
                    .secondSide
                    .height(
                        withWidth: questionLabelWidth,
                        font: .systemFont(ofSize: 24)) + 50
                
            }
            
            var questionLabelY: CGFloat {
                viewModel.cardTapped ? widthOfCard / 4 - questionLabelHeight / 2   : widthOfCard / 2 - questionLabelHeight / 2
                
            }
            
            let answerLabelWidth = widthOfCard - padding * 2
            var answerLabelWidthHeight: CGFloat {
                viewModel.cardTapped ? viewModel
                    .firstSide
                    .height(
                        withWidth: answerLabelWidth,
                        font: .systemFont(ofSize: 24)) + 50  : 0
                
            }
            var iKnowButtonHeight: CGFloat {
                iDontKnowButtonHeight
            }
            var iKnowButtonWidth: CGFloat {
                widthOfCard / 2 - padding - 10
            }
            var offset: CGFloat {
                padding
            }
            
            let questionLabelFrame = CGRect(x: padding,
                                            y: questionLabelY,
                                            width: questionLabelWidth,
                                            height: questionLabelHeight)
            
            let answerLabelFrame = CGRect(x: padding,
                                          y: widthOfCard / 2 - answerLabelWidthHeight / 2 ,
                                          width: answerLabelWidth,
                                          height: answerLabelWidthHeight)
            
            let iDontKnowButtonFrame = CGRect(x: 20,
                                              y: widthOfCard - iDontKnowButtonHeight - padding,
                                              width: iDontKnowButtonWidth,
                                              height: iDontKnowButtonHeight)
            
            let iKnowButtonFrame = CGRect(x: iDontKnowButtonFrame.width + padding * 2,
                                          y: iDontKnowButtonFrame.minY,
                                          width: iKnowButtonWidth,
                                          height: iKnowButtonHeight)
            
            return FinalLayout(
                iDontKnowButtonFrame: iDontKnowButtonFrame,
                iKnowButtonFrame: iKnowButtonFrame,
                questionLabelFrame: questionLabelFrame,
                answerLabelFrame: answerLabelFrame,
                offset: offset,
                widthOfCard: widthOfCard
            )
        }
    }
    
    struct FinalLayout {
        let iDontKnowButtonFrame: CGRect
        let iKnowButtonFrame: CGRect
        let questionLabelFrame: CGRect
        let answerLabelFrame: CGRect
        let offset: CGFloat
        let widthOfCard: CGFloat
        var cardHeight: CGFloat {
            widthOfCard
        }
    }
}

extension CardView {
    struct ViewModel: Equatable {
        var secondSide: String
        var firstSide: String
        let moreButtonIsShowed: Bool
        let descriptionLabelIsShowed: Bool
        var cardTapped: Bool
    }
}

