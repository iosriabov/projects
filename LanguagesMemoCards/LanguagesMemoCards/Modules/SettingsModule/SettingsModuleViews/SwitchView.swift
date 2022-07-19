//
//  SwitchView.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 09.04.2022.
//



import UIKit

final class SwitchView: UIView {
    var finalLayout: FinalLayout?
    var viewModel: ViewModel! {
        didSet {
            guard viewModel != oldValue else {return}
            finalLayout = nil
            labelSwitch.text = viewModel.labelSwitchText
            setNeedsLayout()
        }
    }
    
    private let labelSwitch: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var optionSwitch: UISwitch = {
        let optionSwitch = UISwitch()
        optionSwitch.onTintColor = kGreenColor
        return optionSwitch
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let viewModel = viewModel else { return }
        
        let builder = LayoutBuilder(widthOfCard: frame.width,
                                    viewModel: viewModel, switchWidth: optionSwitch.frame.size.width, switchHeight: optionSwitch.frame.size.height)
        let finalLayout = builder.calculateLayout()
        
        labelSwitch.frame = finalLayout.labelSwitchFrame
        optionSwitch.frame = finalLayout.optionSwitchFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SwitchView {
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        addSubviews([
            labelSwitch,
            optionSwitch
        ])
    }
}

extension SwitchView {
    struct LayoutBuilder {
        let widthOfCard: CGFloat
        let viewModel: ViewModel
        let switchWidth: CGFloat
        let switchHeight: CGFloat
        func calculateLayout() -> FinalLayout {
            let padding: CGFloat = 20
            var labelSwitchHeight: CGFloat {
                viewModel
                    .labelSwitchText
                    .height(
                        withWidth: widthOfCard - padding,
                        font: .systemFont(ofSize: 17))
            }
            
            var offset: CGFloat {
                padding
            }
            let optionSwitchFrame = CGRect(x: widthOfCard - switchWidth - padding , y: padding, width: switchWidth, height: switchHeight)
            let labelSwitchFrame = CGRect(x: padding, y: padding + (switchHeight - labelSwitchHeight) / 2 , width: widthOfCard - switchWidth - 40 , height: labelSwitchHeight)
            
            return FinalLayout(
                optionSwitchFrame: optionSwitchFrame,
                labelSwitchFrame: labelSwitchFrame,
                offset: offset,
                widthOfCard: widthOfCard
            )
        }
    }
    
    struct FinalLayout {
        let optionSwitchFrame: CGRect
        let labelSwitchFrame: CGRect
        let offset: CGFloat
        let widthOfCard: CGFloat
        var cardHeight: CGFloat {
            optionSwitchFrame.maxY
        }
    }
}

extension SwitchView {
    struct ViewModel: Equatable {
        var labelSwitchText: String
        var optionSwitchIsOn: Bool
    }
}



