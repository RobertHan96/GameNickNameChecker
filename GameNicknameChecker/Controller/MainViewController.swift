//
//  ViewController.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var myPageButton: UIBarButtonItem!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchResultTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGesture()
        self.setupTableView()
        self.setupUI()
    }
    
    private func setupUI() {
        titleLabel.adjustsFontSizeToFitWidth = true
        searchButton.layer.cornerRadius = 10
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToMyPage(_:)))

    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveToMyPage(_:)))
    }
    
    private func setupTableView() {
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.register(UINib.init(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
    }
    
    @objc func moveToMyPage(_ sender: UIImage) {
        guard let myPage = self.storyboard?.instantiateViewController(withIdentifier: "myPage") as? MyPageViewController
            else { return }
        self.navigationController?.pushViewController(myPage, animated: true)
    }

    @IBAction func checkNicknameDuplicated(_ sender: UIButton) {
        if let nickname = searchField.text {
            NexonAPI().serachInFifaKartRider(nickname: nickname) { (data) in
                print(data)
            }
            NexonAPI().serachInFifaOnline(nickname: nickname) { (data) in
                print(data)
            }
            NexonAPI().serachInDnf(nickname: nickname) { (data) in
                print(data)
            }
            NexonAPI().serachCyphers(nickname: nickname) { (data) in
                print(data)
            }
            RiotAPI().serachInLoL(nickname: nickname) { (data) in
                print(data)
            }

        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath as IndexPath) as? SearchResultCell else { return UITableViewCell() }
        
        return cell

    }
    
    
}
