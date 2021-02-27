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
    
    private func setupUI() {
        indicatorView.type = .ballPulseSync
        indicatorView.color = .darkGray
        searchButton.layer.cornerRadius = 10
        let iconImage = UIImage(systemName: "person.crop.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(moveToMyPage(_:)))
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
        if let nickname = searchField.text{
            if nickname.count > 1 && nickname != prevName {
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
                prevName = nickname
                indicatorView.stopAnimating()
            } else {
                self.view.makeToast("유효한 이름을 입력하세요", duration: 2.0, position: .center)
            }
        }
    }

    private func setSearchHistory(item: String) {
        var searchHistory = defaults.stringArray(forKey: "searchHistory") ?? [String]()
        searchHistory.append(item)
        defaults.set(searchHistory, forKey: "searchHistory")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath as IndexPath) as? SearchResultCell else { return UITableViewCell() }
        let response =  result[indexPath.row]
        
        cell.gameImage.image = UIImage(named: response.gameName)
        if response.resultCount > 0 {
            // 중복된 이름이 있기 때문에 중복이라고 출력하고, expendable cell 반환
            cell.searchResultLabel.text = "중복"
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
                    cell.serverNameLabel.text = character.server ?? "통합 서버"
                    cell.levelLabel.text = "\(character.level)"
                }
            }
        } else {
            // 게임 이미지만 채워넣고, 생성가능 이라는 문구 출력
            cell.searchResultLabel.text = "생성 가능"
            cell.nameLaebl.text = "-"
            cell.serverNameLabel.text = "-"
            cell.levelLabel.text = "-"
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
