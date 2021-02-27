//
//  ViewController.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import Toast_Swift
import Alamofire
import NVActivityIndicatorView

class MainViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var myPageButton: UIBarButtonItem!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    let defaults = UserDefaults.standard
    var prevName = ""
    var result : [Response] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGesture()
        self.setupTableView()
        self.setupUI()
        searchField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkNetworkConnectivity()
    }
    
    private func setupUI() {
        navigationItem.title = UIStrings.mainNavigationBarTitle
        indicatorView.type = .ballPulseSync
        indicatorView.color = .darkGray
        searchButton.layer.cornerRadius = 10
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.myPageImage, style: .plain, target: self, action: #selector(moveToMyPage(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .systemTeal
    }
    

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveToMyPage(_:)))
    }
    
    private func setupTableView() {
        searchResultTableView.cellLayoutMarginsFollowReadableWidth = false
        searchResultTableView.separatorInset.left = 0
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.register(UINib.init(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
    }
    
    @objc func moveToMyPage(_ sender: UIImage) {
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
               } else {
                // error없이 로그인에 성공한 경우
                   _ = oauthToken
                let accessToken = oauthToken?.accessToken
                self.moveToMyPageView()

               }
                
            }
        }
    }

    private func moveToMyPageView() {
        guard let myPage = self.storyboard?.instantiateViewController(withIdentifier: "myPage") as? MyPageViewController
            else { return }
        self.navigationController?.pushViewController(myPage, animated: true)
    }
        
    @IBAction func checkNicknameDuplicated(_ sender: UIButton) {
        if let nickname = searchField.text {
            if prevName == searchField.text {
                self.view.makeToast(UIStrings.duplicatedInputAlert, duration: 2.0, position: .center)
            } else if nickname.count < 2  {
                self.view.makeToast(UIStrings.shortInputAlert, duration: 2.0, position: .center)
            } else {
                checkNickname(nickname: nickname, prevName: prevName)
            }
        }
    }
    
    private func checkNickname(nickname: String, prevName: String) {
        indicatorView.startAnimating()
        self.searchResultTableView.beginUpdates()
        self.searchResultTableView.endUpdates()

        setSearchHistory(item: nickname)
        APIs().getNicknameData(nickname: nickname) { (response) in
            
            self.result = response
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
        }
        indicatorView.stopAnimating()

    }

    private func setSearchHistory(item: String) {
        let keyString = UIStrings.userDefaultKeyForSearchHistory
        var searchHistory = defaults.stringArray(forKey: keyString) ?? [String]()
        searchHistory.append(item)
        defaults.set(searchHistory, forKey: keyString)
    }
}


extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath as IndexPath) as? SearchResultCell else { return UITableViewCell() }
        let response =  result[indexPath.row]
        
        cell.gameImage.image = UIImage(named: response.gameName)
        if response.resultCount > 0 {
            // 중복된 이름이 있기 때문에 중복이라고 출력하고, expendable cell 반환
            cell.searchResultLabel.text = UIStrings.duplicatedName
            if let character = response.results.first {
                if response.results.count > 1 {
                    var levels: [String] = []
                    var servers: [String] = []
                    for char in response.results {
                        levels.append("\(char.level)")
                        servers.append(char.server ?? "")
                    }
                    
                    cell.nameLaebl.text = character.nmae
                    cell.serverNameLabel.text = servers.joined(separator: ", ")
                    cell.levelLabel.text = levels.joined(separator: ", ")
                } else {
                    cell.nameLaebl.text = character.nmae
                    cell.serverNameLabel.text = character.server ?? UIStrings.oneServer
                    cell.levelLabel.text = "\(character.level)"
                }
            }
        } else {
            // 게임 이미지만 채워넣고, 생성가능 이라는 문구 출력
            cell.searchResultLabel.text = UIStrings.availableName
            cell.nameLaebl.text = UIStrings.emptyDash
            cell.serverNameLabel.text = UIStrings.emptyDash
            cell.levelLabel.text = UIStrings.emptyDash
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchResultCell {
            UIView.animate(withDuration: 0.3) {
                cell.detailView.isHidden = !cell.detailView.isHidden
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
