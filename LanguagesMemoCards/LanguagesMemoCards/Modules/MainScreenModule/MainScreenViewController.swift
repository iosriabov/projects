//
//  MainScreenViewController.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    private let dataProvider = DataProvider()
    
    var level = ""
    private let wordsCoreDataService = WordsCoreDataService()
    private var levelsViewArray = [BlockOfWordsView]()
    private var numberOfOldAndNewWords = 0
    private var numberOfErrorWords = 0
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let generalInfoView = GeneralInfoView()
    private var generalInfoViewViewModel = GeneralInfoView.ViewModel(numberOfOldWords: "Колличество слов для повторения: 0", numberOfNewWords: "Новых слов на сегодня: 0", welcomeLabel: "Добро пожаловать!")
    
    private let blockOfWordsA1BlockView = BlockOfWordsView()
    private var blockOfWordsA1BlockViewModel = BlockOfWordsView.ViewModel(numberOfNewText: "1", numberOfOldText: "1", numberOfMistakesText: "1", titleText: "A1")
    
    private let blockOfWordsA2BlockView = BlockOfWordsView()
    private var blockOfWordsA2BlockViewModel = BlockOfWordsView.ViewModel(numberOfNewText: "1", numberOfOldText: "1", numberOfMistakesText: "1", titleText: "A2")
    
    private let blockOfWordsB1BlockView = BlockOfWordsView()
    private var blockOfWordsB1BlockViewModel = BlockOfWordsView.ViewModel(numberOfNewText: "1", numberOfOldText: "1", numberOfMistakesText: "1", titleText: "B1")
    
    private let blockOfWordsB2BlockView = BlockOfWordsView()
    private var blockOfWordsB2BlockViewModel = BlockOfWordsView.ViewModel(numberOfNewText: "1", numberOfOldText: "1", numberOfMistakesText: "1", titleText: "B2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Главный экран"
        levelsViewArray = [blockOfWordsA1BlockView, blockOfWordsA2BlockView, blockOfWordsB1BlockView, blockOfWordsB2BlockView]
        setupViewModels()
        setupTapGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNumbersOnLevels()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupScrollView()
        addGeneralInfoView()
        setupblockOfWordsA1BlockView()
        setupblockOfWordsA2BlockView()
        setupblockOfWordsB1BlockView()
        setupblockOfWordsB2BlockView()
        setupScrollViewHeight()
    }
    
    
}

//MARK: - PrivateFuncs
extension MainScreenViewController {
    private func goToCardVC(level: String) {
        let cardVC = CardViewController()
        cardVC.level = level
        
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(cardVC, animated: true)
        })
    }
    
    private func openNewLevelAlert() {
        let alert = UIAlertController(title: "Разблокировать уровень?", message: "Нажмите продолжить для разблокировки уровня...", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Продолжить", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            guard let self = self else {return}
            self.dataProvider.loadWordsOfTheLevelFromCoreData(level: self.level) {
            }
            self.wordsCoreDataService.addNewWords(oldID: 0, newID: 30, level: self.level)
            self.updateNumbersOnLevels()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupViewModels() {
        blockOfWordsA1BlockView.viewModel = blockOfWordsA1BlockViewModel
        blockOfWordsA2BlockView.viewModel = blockOfWordsA2BlockViewModel
        blockOfWordsB1BlockView.viewModel = blockOfWordsB1BlockViewModel
        blockOfWordsB2BlockView.viewModel = blockOfWordsB2BlockViewModel
    }
    
    
    private func updateNumbersOnLevels() {
        for levelView in levelsViewArray {
            levelView.viewModel.numberOfNewText = String(wordsCoreDataService.wordsCoreDataServiceCounter.countWordsOfLevelWithPredicate(predicate: Predicate.new, level: levelView.viewModel.titleText))
            
            levelView.viewModel.numberOfOldText = String(wordsCoreDataService.wordsCoreDataServiceCounter.countWordsOfLevelWithPredicate(predicate: Predicate.old, level: levelView.viewModel.titleText))
            
            levelView.viewModel.numberOfMistakesText = String(wordsCoreDataService.wordsCoreDataServiceCounter.countWordsOfLevelWithPredicate(predicate: Predicate.error, level: levelView.viewModel.titleText))
            
        }
        wordsCoreDataService.wordsCoreDataServiceCounter.countOfNewAndOldWordsOnTodayInCoreData { number in
            self.generalInfoViewViewModel.numberOfOldWords = "Колличество слов для повторения: \(number)"
        }
        wordsCoreDataService.wordsCoreDataServiceCounter.countOfNewWordsOnTodayInCoreData { number in
            self.generalInfoViewViewModel.numberOfNewWords = "Новых слов на сегодня: \(number)"
        }
        generalInfoView.viewModel = generalInfoViewViewModel
    }
}

//MARK: - SetupViews
extension MainScreenViewController {
    private func setupScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.frame = view.bounds
    }
    
    private func addGeneralInfoView() {
        
        let generalInfoViewHeight = GeneralInfoView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: generalInfoViewViewModel
        )
            .calculateLayout()
            .cardHeight
        
        let generalInfoViewFrame = CGRect(x: 20,
                                          y: 20,
                                          width: UIScreen.main.bounds.width - 20 - 20,
                                          height: generalInfoViewHeight)
        
        generalInfoView.frame = generalInfoViewFrame
        contentView.addSubview(generalInfoView)
    }
    
    private func setupblockOfWordsA1BlockView() {
        let generalInfoViewHeight = BlockOfWordsView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: blockOfWordsA1BlockViewModel
        )
            .calculateLayout()
            .cardHeight
        
        let blockOfWordsA1BlockViewFrame = CGRect(x: 20,
                                                  y: generalInfoView.frame.maxY + 20,
                                                  width: UIScreen.main.bounds.width - 20 - 20,
                                                  height: generalInfoViewHeight)
        
        blockOfWordsA1BlockView.frame = blockOfWordsA1BlockViewFrame
        contentView.addSubview(blockOfWordsA1BlockView)
    }
    
    private func setupblockOfWordsA2BlockView() {
        let generalInfoViewHeight = BlockOfWordsView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: blockOfWordsA2BlockViewModel
        )
            .calculateLayout()
            .cardHeight
        
        let blockOfWordsA2BlockViewFrame = CGRect(x: 20,
                                                  y: blockOfWordsA1BlockView.frame.maxY + 10,
                                                  width: UIScreen.main.bounds.width - 20 - 20,
                                                  height: generalInfoViewHeight)
        
        blockOfWordsA2BlockView.frame = blockOfWordsA2BlockViewFrame
        contentView.addSubview(blockOfWordsA2BlockView)
    }
    
    private func setupblockOfWordsB1BlockView() {
        let generalInfoViewHeight = BlockOfWordsView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: blockOfWordsB1BlockViewModel
        )
            .calculateLayout()
            .cardHeight
        
        let blockOfWordsB1BlockViewFrame = CGRect(x: 20,
                                                  y: blockOfWordsA2BlockView.frame.maxY + 10,
                                                  width: UIScreen.main.bounds.width - 20 - 20,
                                                  height: generalInfoViewHeight)
        blockOfWordsB1BlockView.frame = blockOfWordsB1BlockViewFrame
        contentView.addSubview(blockOfWordsB1BlockView)
    }
    
    private func setupblockOfWordsB2BlockView() {
        let generalInfoViewHeight = BlockOfWordsView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: blockOfWordsB2BlockViewModel
        )
            .calculateLayout()
            .cardHeight
        
        let blockOfWordsB2BlockViewFrame = CGRect(x: 20,
                                                  y: blockOfWordsB1BlockView.frame.maxY + 10,
                                                  width: UIScreen.main.bounds.width - 20 - 20,
                                                  height: generalInfoViewHeight)
        
        blockOfWordsB2BlockView.frame = blockOfWordsB2BlockViewFrame
        contentView.addSubview(blockOfWordsB2BlockView)
    }
    
    private func setupScrollViewHeight() {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width
                                        , height: blockOfWordsB2BlockView.frame.maxY + 20)
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: blockOfWordsB2BlockView.frame.maxY + 20)
    }
}

//MARK: - HandlingTapGesture
extension MainScreenViewController {
    private func setupTapGesture() {
        for levelView in levelsViewArray {
            let tapGesture = UITapGestureRecognizer(target: self, action:#selector(didTapBlockLevel(sender:)))
            levelView.isUserInteractionEnabled = true
            levelView.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func didTapBlockLevel(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            sender.view?.transform = .init(scaleX: 0.9, y: 0.9)
            sender.view?.backgroundColor = kGreenColor
        }) { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                sender.view?.transform = .identity
                sender.view?.backgroundColor = .white
            })
        }
        switch sender.view {
        case self.blockOfWordsA1BlockView:
            level = blockOfWordsA1BlockView.viewModel.titleText
            dataProvider.checkIfThereAreWordsOfThisLevelInCoreData(level: blockOfWordsA1BlockView.viewModel.titleText) { [weak self] isZero in
                if isZero {
                    self?.openNewLevelAlert()
                } else {
                    guard let level = self?.level else { return }
                    self?.goToCardVC(level: level)
                }
            }
        case self.blockOfWordsA2BlockView:
            level = blockOfWordsA2BlockView.viewModel.titleText
            dataProvider.checkIfThereAreWordsOfThisLevelInCoreData(level: blockOfWordsA2BlockView.viewModel.titleText) { [weak self] isZero in
                if isZero {
                    self?.openNewLevelAlert()
                } else {
                    guard let level = self?.level else { return }
                    self?.goToCardVC(level: level)
                }
            }
        case self.blockOfWordsB1BlockView:
            level = blockOfWordsB1BlockView.viewModel.titleText
            dataProvider.checkIfThereAreWordsOfThisLevelInCoreData(level: blockOfWordsB1BlockView.viewModel.titleText) { [weak self] isZero in
                if isZero {
                    self?.openNewLevelAlert()
                } else {
                    guard let level = self?.level else { return }
                    self?.goToCardVC(level: level)
                }
            }
        case self.blockOfWordsB2BlockView:
            level = blockOfWordsB2BlockView.viewModel.titleText
            dataProvider.checkIfThereAreWordsOfThisLevelInCoreData(level: blockOfWordsB2BlockView.viewModel.titleText) { [weak self] isZero in
                if isZero {
                    self?.openNewLevelAlert()
                } else {
                    guard let level = self?.level else { return }
                    self?.goToCardVC(level: level)
                }
            }
        default:
            print("Tap not detected")
        }
    }
}

