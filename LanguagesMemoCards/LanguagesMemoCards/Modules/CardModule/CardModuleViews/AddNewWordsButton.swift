//
//  addNewWordsButton.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 09.04.2022.
//

import UIKit

final class AddNewWordsButton: UIView {
    var finalLayout: FinalLayout?
    var viewModel: ViewModel! {
        didSet {
            guard viewModel != oldValue else {return}
            finalLayout = nil
            setNeedsLayout()
        }
    }
    
    lazy var addNewWordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = kGreenColor
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
        
        addNewWordsButton.frame = finalLayout.moreButtonFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddNewWordsButton {
    private func setupView() {
        backgroundColor = .white
        
        addSubviews([
            addNewWordsButton
        ])
        layer.cornerRadius = 12
        layer.borderWidth = 4
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
    }
}

extension AddNewWordsButton {
    struct LayoutBuilder {
        let widthOfCard: CGFloat
        let viewModel: ViewModel
        func calculateLayout() -> FinalLayout {
            let padding: CGFloat = 20
            var moreButtonHeight: CGFloat {
                36
            }
            var moreButtonWidth: CGFloat {
                widthOfCard - padding * 2
            }
            var offset: CGFloat {
                padding
            }
            
            let moreButtonFrame = CGRect(x: padding,
                                         y: padding,
                                         width: moreButtonWidth,
                                         height: moreButtonHeight)
            
            return FinalLayout(
                moreButtonFrame: moreButtonFrame,
                offset: offset
            )
        }
    }
    
    struct FinalLayout {
        let moreButtonFrame: CGRect
        let offset: CGFloat
        var cardHeight: CGFloat {
            moreButtonFrame.maxY + offset
        }
    }
}

extension AddNewWordsButton {
    struct ViewModel: Equatable {
        let moreButtonIsActive: Bool
    }
}
