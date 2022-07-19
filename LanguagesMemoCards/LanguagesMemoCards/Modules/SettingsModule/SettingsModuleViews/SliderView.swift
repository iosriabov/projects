////
////  SliderView.swift
////  LanguagesMemoCards
////
////  Created by Владимир Рябов on 09.04.2022.
////



import UIKit

final class SliderView: UIView {
    var finalLayout: FinalLayout?
    var viewModel: ViewModel! {
        didSet {
            guard viewModel != oldValue else {return}
            finalLayout = nil
            labelOfMenu.text = viewModel.labelOfMenuText
            minLabel.text = viewModel.minLabelText
            maxLabel.text = viewModel.maxLabelText
            setNeedsLayout()
        }
    }
    
    private let labelOfMenu: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var timeSlider: UISlider = {
        let timeSlider = UISlider()
        timeSlider.minimumTrackTintColor = kBlueColor
        timeSlider.maximumValue = 10
        timeSlider.minimumValue = 2
        timeSlider.isContinuous = false
        return timeSlider
    }()
    
    private let minLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    
    private let maxLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "10"
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
        labelOfMenu.frame = finalLayout.labelOfMenuFrame
        timeSlider.frame = finalLayout.timeSliderFrame
        minLabel.frame = finalLayout.minLabelFrame
        maxLabel.frame = finalLayout.maxLabelFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SliderView {
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        addSubviews([
            labelOfMenu,
            timeSlider,
            minLabel,
            maxLabel
        ])
    }
}

extension SliderView {
    struct LayoutBuilder {
        let widthOfCard: CGFloat
        let viewModel: ViewModel
        func calculateLayout() -> FinalLayout {
            let padding: CGFloat = 20
            var labelOfMenuHeight: CGFloat {
                viewModel
                    .labelOfMenuText
                    .height(
                        withWidth: widthOfCard - padding,
                        font: .systemFont(ofSize: 17))
            }
            
            var minLabelHeight: CGFloat {
                viewModel
                    .minLabelText
                    .height(
                        withWidth: widthOfCard - padding,
                        font: .systemFont(ofSize: 17))
            }
            
            var offset: CGFloat {
                padding
            }
            
            let labelOfMenuFrame = CGRect(x: padding, y: padding, width: widthOfCard - padding, height: labelOfMenuHeight)
            let minLabelFrame = CGRect(x: padding, y: labelOfMenuFrame.minY + 30, width: 20, height: minLabelHeight)
            let maxLabelFrame = CGRect(x: widthOfCard - padding - 20, y: labelOfMenuFrame.minY + 30, width: 20, height: minLabelHeight)
            let timeSliderFrame = CGRect(x: minLabelFrame.maxX, y: labelOfMenuFrame.minY + 30, width: widthOfCard - padding*2 - 20 - 20 - 10, height: 17)
            
            return FinalLayout(
                labelOfMenuFrame: labelOfMenuFrame,
                minLabelFrame: minLabelFrame,
                maxLabelFrame: maxLabelFrame,
                timeSliderFrame: timeSliderFrame,
                offset: offset,
                widthOfCard: widthOfCard
            )
        }
    }
    
    struct FinalLayout {
        let labelOfMenuFrame: CGRect
        let minLabelFrame: CGRect
        let maxLabelFrame: CGRect
        let timeSliderFrame: CGRect
        let offset: CGFloat
        let widthOfCard: CGFloat
        var cardHeight: CGFloat {
            maxLabelFrame.maxY + offset
        }
    }
}

extension SliderView {
    struct ViewModel: Equatable {
        var minLabelText: String
        var maxLabelText: String
        var labelOfMenuText: String
        
    }
}



