//
//  ViewController.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class MainViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var myPageButton: UIBarButtonItem!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchResultTableView: UITableView!
    var result : [Response] = []
    
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
        result = []
        self.searchResultTableView.reloadData()

        if let nickname = searchField.text{
            let group = DispatchGroup()
            let queue = DispatchQueue.global(qos: .userInteractive)
            queue.async {
                NexonAPI().serachInFifaKartRider(nickname: nickname) { (data) in
                    print("LOG - KartRider",data)
                    self.result.append(data)
                    self.searchResultTableView.reloadData()
                    print(self.result)
                }
            }
            queue.async {
                NexonAPI().serachInFifaOnline(nickname: nickname) { (data) in
                    print("LOG - FIFA Online",data)
                    self.result.append(data)
                    self.searchResultTableView.reloadData()

                    print(self.result)

                }
            }
            queue.async {
                NexonAPI().serachInDnf(nickname: nickname) { (data) in
                    print("LOG - DNF",data)
                    self.result.append(data)
                    self.searchResultTableView.reloadData()

                    print(self.result)

                }

            }
            queue.async {
                NexonAPI().serachCyphers(nickname: nickname) { (data) in
                    print("LOG - Cyphers",data)
                    self.result.append(data)
                    self.searchResultTableView.reloadData()

                    print(self.result)

                }
            }

            queue.async {
                RiotAPI().serachInLoL(nickname: nickname) { (data) in
                    print("LOG - LOL",data)
                    self.result.append(data)
                    self.searchResultTableView.reloadData()

                    print(self.result)

                }
            }
            
            group.notify(queue: queue) {
                print("LOG - 모든 API 확인 완료 결과 반환...")
            }
        } else {
            print("이름을 입력해주세요.")
        }
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
        } else {
            // 게임 이미지만 채워넣고, 생성가능 이라는 문구 출력
            cell.searchResultLabel.text = "생성 가능"
        }
        
        return cell

    }
    
    
}
