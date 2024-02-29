//
//  ViewController.swift
//  CombineMVVMTest
//
//  Created by Vitaliy Halai on 29.02.24.
//

import UIKit
import Combine

class MyCustomTableCell: UITableViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Tap Me", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var action = PassthroughSubject<String, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.frame = CGRect(x: 10, y: 5, width: contentView.frame.width - 20, height:  contentView.frame.height - 10)
    }
    
    @objc private func didTapButton() {
        action.send("Cool button was tapped")
    }
    
    
}

class ViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register( MyCustomTableCell.self
            , forCellReuseIdentifier: "cell")
        return table
    }()
    
    var observers = Set<AnyCancellable>()
    var models = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        ApiCaller.shared.fetchCompanies()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                self.models = value
                print(Thread.current)
                self.tableView.reloadData()
            })
            .store(in: &observers)
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else { fatalError() }
        //cell.textLabel?.text = models[indexPath.row]
        cell.action.sink { value in
            print("\(value) for row \(indexPath.row)")
        }.store(in: &observers)
        return cell
    }
    
    
}
