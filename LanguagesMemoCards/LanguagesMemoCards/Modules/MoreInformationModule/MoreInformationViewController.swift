//
//  MIVC.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 10.04.2022.
//

import UIKit


class MoreInformationViewController: UIViewController {
    var word = ""
    var meanings = [Meanings]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = word
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
}

extension MoreInformationViewController: UITableViewDataSource, UITableViewDelegate {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        meanings.count
    }
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        meanings[section].partOfSpeech
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meanings[section].definitions.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        cell.detailTextLabel?.font = .systemFont(ofSize: 15, weight: .light)
        
        cell.textLabel?.text = "\(meanings[indexPath.section].definitions[indexPath.row].definition)"
        cell.detailTextLabel?.text = meanings[indexPath.section].definitions[indexPath.row].example
        
        return cell
    }
}



