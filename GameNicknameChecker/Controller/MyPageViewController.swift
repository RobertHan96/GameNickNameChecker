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
    @IBOutlet weak var userHistoryTableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    var searchHistory = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchHistory.reversed()
        userHistoryTableView.reloadData()
    }
        
    private func setupUI() {
        setUserInfo()
        let iconImage = UIImage(named: "logout")?.resizeImage(size: CGSize(width: 26, height: 26))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(logOut))
    }
    
    private func setupTableView() {
        userHistoryTableView.cellLayoutMarginsFollowReadableWidth = false
        userHistoryTableView.separatorInset.left = 0
        userHistoryTableView.dataSource = self
        userHistoryTableView.delegate = self
        userHistoryTableView.register(UINib.init(nibName: "SearchHistoryCell", bundle: nil), forCellReuseIdentifier: "SearchHistoryCell")
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
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryCell", for: indexPath as IndexPath) as? SearchHistoryCell else { return UITableViewCell() }
        if searchHistory.count > 0 {
            cell.searchKeywordLabel.text = searchHistory[indexPath.row]
        } else {
            cell.searchKeywordLabel.text = "검색 내역이 없습니다"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
