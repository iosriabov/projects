//
//  AllWordsViewController.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 27.03.2022.
//


import UIKit
import CoreData

class AllWordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var wordsCoreDataService = WordsCoreDataService()
    var oldWords = [Wordd]()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = UITableView.automaticDimension
        tv.backgroundColor = .secondarySystemBackground
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Список изученных"
        view.backgroundColor = .secondarySystemBackground
        wordsCoreDataService.wordsCoreDataServiceCounter.getOldWordsFromCoreData { [weak self] words in
            guard let self = self else {return}
            self.oldWords = words
        }
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wordsCoreDataService.wordsCoreDataServiceCounter.getOldWordsFromCoreData { [weak self] words in
            guard let self = self else {return}
            self.oldWords = words
        }
        tableView.reloadData()
    }
}

extension AllWordsViewController {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oldWords.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = kBlueColor
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.textLabel?.text = "\(String(describing: oldWords[indexPath.row].englishWord ?? "")) \(String(describing: oldWords[indexPath.row].level ?? ""))"
        cell.detailTextLabel?.text = "\(String(describing: oldWords[indexPath.row].russianWord ?? "")) \nДата появления: \(String(describing: oldWords[indexPath.row].dataToAppear?.formatted(date: .complete, time: .omitted ) ?? ""))"
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
}
