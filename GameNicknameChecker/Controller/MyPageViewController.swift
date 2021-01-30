//
//  MyPageViewController.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class MyPageViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var myHistoryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()

    }
    
    private func setupUI() {
        setUserInfo()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(logOut))
    }
    
    private func setupTableView() {
        myHistoryTableView.dataSource = self
        myHistoryTableView.delegate = self
        myHistoryTableView.register(UINib.init(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
    }
    
    @objc func logOut() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
                
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                _ = user
                if let nickname = user?.kakaoAccount?.profile?.nickname {
                    if let url = user?.kakaoAccount?.profile?.profileImageUrl,
                        let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.profileImageView.image = UIImage(data: data)
                            self.userNameLabel.text = "\(nickname)님의 검색 기록"
                        }
                    }
                }
            }
        }
    }


}

extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath as IndexPath) as? SearchResultCell else { return UITableViewCell() }
        
        return cell

    }

    
    
}
