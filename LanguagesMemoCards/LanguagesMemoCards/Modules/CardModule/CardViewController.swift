//
//  ViewController.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import UIKit
import CoreData

final class CardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var level = ""
    
    private var timeRemaining: Int = UserDefaultsHelper.getData(type: Int.self, forKey: .timeForQuestion) ?? 10
    private var timeForAnswer: Int = UserDefaultsHelper.getData(type: Int.self, forKey: .timeForAnswer) ?? 3
    private var timer: Timer?
    private var firstInterval = true
    private var timerIsOn = false
    private var cardWasTapped = false
    private var word: String?
    private var meanings = [Meanings]()
    private let wordsCoreDataService = WordsCoreDataService()
    private let cardOrder = UserDefaultsHelper.getData(type: Bool.self, forKey: .isTranslateFirst)
    var currentWord: Wordd? {
        didSet {
            fetchMoreInformationAboutCurrentWord()
        }
    }
    private var statusNumbers = [Int]()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let cardView = CardView()
    private var cardViewViewModel = CardView.ViewModel(secondSide: "House", firstSide: "Дом", moreButtonIsShowed: true, descriptionLabelIsShowed: true, cardTapped: false)
    
    private let statusView = StatusView()
    private var statusViewViewModel = StatusView.ViewModel(numberOfNewText: "20", numberOfOldText: "19", numberOfMistakesText: "18")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Уровень - \(level)"
        let addWordsNavigationBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWordsTapped))
        navigationItem.rightBarButtonItems = [addWordsNavigationBarItem]
        fetchingInformation()
        setupScrollView()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCardView()
        setupStatusView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStatusInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deleteTimer()
    }
}
//MARK: - Setup Views
extension CardViewController {
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width
                                        , height: cardView.frame.maxY + 20 )
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500)
    }
    
    private func setupCardView() {
        let firstCardHeight = CardView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: cardViewViewModel
        )
            .calculateLayout()
            .cardHeight
        
        let firstFrame = CGRect(x: 20,
                                y: 20,
                                width: UIScreen.main.bounds.width - 20 - 20,
                                height: firstCardHeight)
        cardView.frame = firstFrame
        contentView.addSubview(cardView)
        cardView.iDontKnowButton.addTarget(self, action: #selector(iDontKnowButtonPressed), for: .touchUpInside)
        cardView.iKnowButton.addTarget(nil, action: #selector(iKnowButtonPressed), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector (cardTapped))
        cardView.addGestureRecognizer(tapGesture)
    }
    
    private func setupStatusView() {
        let statusViewFrameHeight = StatusView.LayoutBuilder(
            widthOfCard: UIScreen.main.bounds.width - 20 - 20,
            viewModel: statusViewViewModel
        )
            .calculateLayout()
            .cardHeight
        
        
        let statusViewFrame = CGRect(x: 20,
                                     y: cardView.frame.maxY + 10 ,
                                     width: UIScreen.main.bounds.width - 20 - 20,
                                     height: statusViewFrameHeight)
        statusView.frame = statusViewFrame
        statusView.viewModel = statusViewViewModel
        contentView.addSubview(statusView)
        statusView.moreButton.addTarget(self, action: #selector(toMoreInformation), for: .touchUpInside)
        statusView.playButton.addTarget(nil, action: #selector(timerButtonPressed), for: .touchUpInside)
    }
}

//MARK: - Private funcs
extension CardViewController {
    private func fetchingInformation() {
        getCurrentWord()
        getStatusInfo()
        fetchMoreInformationAboutCurrentWord()
    }
    
    private func getStatusInfo() {
        statusViewViewModel.numberOfNewText = String(wordsCoreDataService.wordsCoreDataServiceCounter.countWordsOfLevelWithPredicate(predicate: .new, level: level))
        statusViewViewModel.numberOfOldText = String(wordsCoreDataService.wordsCoreDataServiceCounter.countWordsOfLevelWithPredicate(predicate: .old, level: level))
        statusViewViewModel.numberOfMistakesText = String(wordsCoreDataService.wordsCoreDataServiceCounter.countWordsOfLevelWithPredicate(predicate: .error, level: level))
        statusView.viewModel = statusViewViewModel
    }
    
    private func getCurrentWord() {
        wordsCoreDataService.currentWordGet(level: level)
        currentWord = wordsCoreDataService.currentWord
        
        if cardOrder ?? false {
            cardViewViewModel.secondSide = currentWord?.russianWord ?? ""
            cardViewViewModel.firstSide = currentWord?.englishWord ?? ""
        } else {
            cardViewViewModel.secondSide = currentWord?.englishWord ?? ""
            cardViewViewModel.firstSide = currentWord?.russianWord ?? ""
        }
        
        cardView.viewModel = cardViewViewModel
    }
    
    private func fetchMoreInformationAboutCurrentWord() {
        guard let word = currentWord?.englishWord else {return}
        StockService.shared.fetchListOfWords(word: word, completion:  { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.word = response.array[0].word
                    for res in response.array {
                        self.meanings = res.meanings
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func updateInformation() {
        wordsCoreDataService.coreDataStack.saveContext()
        getCurrentWord()
        getStatusInfo()
    }
}
//MARK: - Buttons selectors
extension CardViewController {
    @objc func iKnowButtonPressed() {
        
        currentWord?.dataToAppear = Date().dayAfter
        currentWord?.state = "2"
        updateInformation()
        changeTimerWhenButtonWasTapped()
        UIView.transition(with: cardView, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    @objc func iDontKnowButtonPressed() {
        currentWord?.dataToAppear = Date().minuteAfter
        currentWord?.state = "1"
        changeTimerWhenButtonWasTapped()
        UIView.animate(withDuration: 10.0, delay: 0, options: [.curveEaseIn], animations: { [weak self] in
            let animation:CATransition = CATransition()
            animation.type = CATransitionType.push
            animation.subtype = .fromRight
            self?.updateInformation()
            animation.duration = 0.5
            self?.cardView.layer.add(animation, forKey: CATransitionType.push.rawValue)
        }, completion: nil)
    }
    
    @objc func cardTapped() {
        if cardViewViewModel.cardTapped == false {
            cardWasTapped = true
            changeTimeWhenCardTapped()
            cardViewViewModel.cardTapped = true
            cardView.viewModel = cardViewViewModel
            UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        } else {
            return
        }
    }
    
    @objc func timerButtonPressed() {
        timerIsOn.toggle()
        if timerIsOn {
            startTimer()
        } else {
            deleteTimer()
        }
    }
    
    @objc func toMoreInformation() {
        let vc = MoreInformationViewController()
        vc.word = word ?? "error"
        vc.meanings = meanings
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
    }
    
    @objc func addWordsTapped() {
        let vc = AddNewWordsViewController()
        vc.level = level
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
    }
}


//MARK: - Timer Functions
extension CardViewController {
    private func startTimer() {
        if cardWasTapped {
            timeRemaining = timeForAnswer
        } else {
            timeRemaining = UserDefaultsHelper.getData(type: Int.self, forKey: .timeForQuestion) ?? 10
        }
        timerIsOn = true
        statusView.secondsRemainingLabel.text = "\(timeRemaining)"
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatingTimerInSecond), userInfo: nil, repeats: true)
    }
    
    private func timerRestart() {
        deleteTimer()
        cardWasTapped = false
        startTimer()
    }
    
    private func deleteTimer() {
        timerIsOn = false
        timer?.invalidate()
        timer = nil
        statusView.secondsRemainingLabel.text = ""
    }
    
    @objc func updatingTimerInSecond() {
        if timerIsOn {
            if cardWasTapped {
                statusView.secondsRemainingLabel.text = "\(timeRemaining)"
                if timeRemaining >= 0 {
                    timeRemaining -= 1
                } else {
                    iDontKnowButtonPressed()
                    timerRestart()
                }
            } else {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    statusView.secondsRemainingLabel.text = "\(timeRemaining)"
                } else {
                    cardWasTapped = true
                    timeRemaining = timeForAnswer
                    statusView.secondsRemainingLabel.text = "\(timeRemaining)"
                    timeRemaining -= 1
                    cardTapped()
                }
            }
        } else {
            deleteTimer()
        }
    }
    
    private func changeTimerWhenButtonWasTapped() {
        if cardViewViewModel.cardTapped == true {
            cardViewViewModel.cardTapped = false
            cardView.viewModel = cardViewViewModel
        } else {
            return
        }
        cardWasTapped = false
        if timerIsOn == true {
            timerRestart()
        } else {
            return
        }
    }
    
    private func changeTimeWhenCardTapped() {
        if timerIsOn == true {
            cardWasTapped = true
            timeRemaining = timeForAnswer
            statusView.secondsRemainingLabel.text = "\(timeRemaining)"
            timeRemaining -= 1
        } else {
            return
        }
    }
    
}

