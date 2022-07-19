//
//  SettingsViewController.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 09.04.2022.
//


import UIKit

final class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let switchView = SwitchView()
    private var switchViewViewModel = SwitchView.ViewModel(labelSwitchText: "Сначала перевод:", optionSwitchIsOn: false)
    
    private let timerQuestionView = SliderView()
    private var timerQuestionViewViewModel = SliderView.ViewModel(minLabelText: "2", maxLabelText: "10", labelOfMenuText: "Время вопроса: ")
    
    private let timerAnswerView = SliderView()
    private var timerAnswerViewViewModel = SliderView.ViewModel(minLabelText: "2", maxLabelText: "10", labelOfMenuText: "Время ответа: ")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Настройки"
        setupScrollView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupSwitchView()
        setupTimerQuestionView()
        setupTimerAnswerView()
    }
    
}
//MARK: - Setup Views
extension SettingsViewController {
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width
                                        , height: switchView.frame.maxY + 20 )
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500)
    }
    
    private func setupSwitchView() {
        switchView.optionSwitch.isOn = UserDefaultsHelper.getData(type: Bool.self, forKey: .isTranslateFirst) ?? false
        switchView.viewModel = switchViewViewModel
        let firstCardHeight = SwitchView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: switchViewViewModel, switchWidth: switchView.optionSwitch.frame.size.width, switchHeight: switchView.optionSwitch.frame.size.width
        )
            .calculateLayout()
            .cardHeight
        
        let firstFrame = CGRect(x: 20,
                                y: 20,
                                width: UIScreen.main.bounds.width - 20 - 20,
                                height: firstCardHeight)
        switchView.frame = firstFrame
        contentView.addSubview(switchView)
        switchView.optionSwitch.addTarget(self, action: #selector(optionSwitchValueChanged), for: .valueChanged)
        
    }
    
    private func setupTimerQuestionView() {
        timerQuestionViewViewModel.labelOfMenuText = "Время вопроса: \(UserDefaultsHelper.getData(type: Int.self, forKey: .timeForQuestion) ?? 10)"
        timerQuestionView.timeSlider.value = Float(UserDefaultsHelper.getData(type: Int.self, forKey: .timeForQuestion) ?? 10)
        timerQuestionView.viewModel = timerQuestionViewViewModel
        let firstCardHeight = SliderView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: timerQuestionViewViewModel
        )
            .calculateLayout()
            .cardHeight
        
        let firstFrame = CGRect(x: 20,
                                y: switchView.frame.maxY + 10,
                                width: UIScreen.main.bounds.width - 20 - 20,
                                height: firstCardHeight)
        timerQuestionView.frame = firstFrame
        contentView.addSubview(timerQuestionView)
        timerQuestionView.timeSlider.addTarget(self, action: #selector(timeQuestionSliderValueChanged), for: .valueChanged)
    }
    
    private func setupTimerAnswerView() {
        timerAnswerViewViewModel.labelOfMenuText = "Время ответа: \(UserDefaultsHelper.getData(type: Int.self, forKey: .timeForAnswer) ?? 3)"
        timerAnswerView.timeSlider.value = Float(UserDefaultsHelper.getData(type: Int.self, forKey: .timeForAnswer) ?? 3)
        timerAnswerView.viewModel = timerAnswerViewViewModel
        let firstCardHeight = SliderView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: timerAnswerViewViewModel
        )
            .calculateLayout()
            .cardHeight
        
        let firstFrame = CGRect(x: 20,
                                y: timerQuestionView.frame.maxY + 10,
                                width: UIScreen.main.bounds.width - 20 - 20,
                                height: firstCardHeight)
        timerAnswerView.frame = firstFrame
        contentView.addSubview(timerAnswerView)
        timerAnswerView.timeSlider.addTarget(self, action: #selector(timeAnswerSliderValueChanged), for: .valueChanged)
    }
}

//MARK: - Selectors

extension SettingsViewController {
    @objc func timeQuestionSliderValueChanged(sender: UISlider) {
        timerQuestionView.viewModel.labelOfMenuText = "Время вопроса: \(Int(sender.value))"
        UserDefaultsHelper.setData(value: Int(sender.value) , key: .timeForQuestion)
    }
    
    @objc func timeAnswerSliderValueChanged(sender: UISlider) {
        self.timerAnswerView.viewModel.labelOfMenuText = "Время ответа: \(Int(sender.value))"
        UserDefaultsHelper.setData(value: Int(sender.value) , key: .timeForAnswer)
    }
    
    @objc func optionSwitchValueChanged(sender: UISwitch) {
        if sender.isOn {
            UserDefaultsHelper.setData(value: true , key: .isTranslateFirst)
        } else {
            UserDefaultsHelper.setData(value: false , key: .isTranslateFirst)
        }
    }
}
