//
//  AddNewWordsViewController.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 09.04.2022.
//

import UIKit

final class AddNewWordsViewController: UIViewController {
    var level = ""
    
    private let dataProvider = DataProvider()
    private let fetcher = WordsCoreDataService()
    
    private var oldID = 0
    private var newID = 0
    private var availableNumberOfWords = 0
    
    private let validityType: String.ValidityType = .age
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let contentView: UIView = {
        
        let view = UIView()
        return view
    }()
    
    private let cardWithTextField = CardWithSelfValidTextField()
    private var cardWithSelfValidTextFieldVieModel = CardWithSelfValidTextField.ViewModel(pickTitle: "Cколько слов вы хотели бы добавить?", pickDescription: "Рекомендация - добавлять не более 30 новых слов в сутки.\n \nНовых слов доступно: ", validationLabelIsShowed: true, descriptionLabelIsShowed: true, pickButtonIsPressed: true)
    
    private let addNewWordsButtonView = AddNewWordsButton()
    private let addNewWordsButtonViewModel = AddNewWordsButton.ViewModel(moreButtonIsActive: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInfo()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width
                                        , height: addNewWordsButtonView.frame.maxY + 20 )
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: addNewWordsButtonView.frame.maxY + 40)
    }
}

//MARK: - PrivateFuncs
extension AddNewWordsViewController {
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        title = "Добавить новые слова"
        setupScrollView()
        setupCardWithSelfValidTextField()
        setupAddNewWordsButtonView()
    }
    
    private func updateInfo() {
        dataProvider.dataProviderCounter.numberOfUnexploredCards(level: level) { number in
            self.availableNumberOfWords = number
        }
        dataProvider.dataProviderCounter.countOfWordsWithoutDataOfLevelInCoreData(level: level) { oldID in
            self.oldID = oldID
        }
        cardWithTextField.viewModel.pickDescription = "Рекомендация - добавлять не более 30 новых слов в сутки.\n \nНовых слов доступно: \(availableNumberOfWords) \nСлов на изучении: \(oldID) "
    }
}

//MARK: - SetupViews
extension AddNewWordsViewController {
    private func setupScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.frame = view.bounds
    }
    
    private func setupCardWithSelfValidTextField(){
        cardWithTextField.viewModel = cardWithSelfValidTextFieldVieModel
        contentView.addSubview(cardWithTextField)
        let cardWithTextFieldFrameHeight = CardWithSelfValidTextField.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: cardWithSelfValidTextFieldVieModel
        )
            .calculateLayout()
            .cardHeight
        let cardWithTextFieldFrame = CGRect(x: 20,
                                            y: 20,
                                            width: UIScreen.main.bounds.width - 20 - 20,
                                            height: cardWithTextFieldFrameHeight + 20)
        cardWithTextField.frame = cardWithTextFieldFrame
        cardWithTextField.newWordTextField.delegate = self
        cardWithTextField.newWordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    }
    
    private func setupAddNewWordsButtonView() {
        addNewWordsButtonView.viewModel = addNewWordsButtonViewModel
        contentView.addSubview(addNewWordsButtonView)
        let addNewWordsButtonViewFrameHeight = AddNewWordsButton.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: addNewWordsButtonViewModel
        )
            .calculateLayout()
            .cardHeight
        
        let addNewWordsButtonViewFrame = CGRect(x: 20,
                                                y: cardWithTextField.frame.maxY + 10 ,
                                                width: UIScreen.main.bounds.width - 20 - 20,
                                                height: addNewWordsButtonViewFrameHeight)
        
        addNewWordsButtonView.frame = addNewWordsButtonViewFrame
        addNewWordsButtonView.addNewWordsButton.isEnabled = false
        addNewWordsButtonView.addNewWordsButton.addTarget(nil, action: #selector(addNewWordsButtonPressed), for: .touchUpInside)
    }
    
}
//MARK: - Selectors
extension AddNewWordsViewController {
    @objc func addNewWordsButtonPressed() {
        guard let input = cardWithTextField.newWordTextField.text else {return}
        let new = (Int(input) ?? 0) + oldID
        fetcher.addNewWords(oldID: oldID , newID: new, level: level)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddNewWordsViewController {
    @objc fileprivate func handleTextChange() {
        guard let text = cardWithTextField.newWordTextField.text  else { return }
        cardWithTextField.validationLabel.transform = CGAffineTransform(translationX: 0, y: -20).scaledBy(x: 1.0, y: 0.0)
        if cardWithTextField.newWordTextField.text == "" {
            addNewWordsButtonView.addNewWordsButton.isEnabled = false
        } else {
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           options: .transitionFlipFromBottom,
                           animations: {
                self.cardWithTextField.validationLabel.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1.0, y: 1.0)
            }, completion: nil)
            switch validityType {
            case .age:
                if text.isValid(validityType) {
                    cardWithTextField.validationLabel.textColor = UIColor(red: 130.0/255.0, green: 236.0/255.0, blue: 130.0/255.0, alpha: 1.0)
                    cardWithTextField.validationLabel.text = "Вы указали верное колличество"
                    addNewWordsButtonView.addNewWordsButton.isEnabled = true
                } else {
                    cardWithTextField.validationLabel.text = "Ошибка, проверьте поле ввода"
                    cardWithTextField.validationLabel.textColor = .systemRed
                    addNewWordsButtonView.addNewWordsButton.isEnabled = false
                }
            }
        }
    }
}

extension AddNewWordsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cardWithTextField.newWordTextField.resignFirstResponder()
        return true
    }
}

