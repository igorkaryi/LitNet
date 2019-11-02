//
//  ViewController.swift
//  LitNet
//
//  Created by Igor Karyi on 30.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: BaseViewController {
    
    @IBOutlet fileprivate weak var tabBarView: TabBarView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    enum ListMode: Int {
        case reading
        case archive
        case favorites
    }
    
    private var listMode = ListMode.reading
    
    private var disposeBag = DisposeBag()
    private var viewModel: MainProtocol?
    
    private var libraries = [Library]()
    private var readingLibrary = [Library]()
    private var archiveLibrary = [Library]()
    private var favoritesLibrary = [Library]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        setupTabBarItems()
        
        viewModel = MainViewModel()
        getLibrary()
        listModeType(.reading, animated: false)

        tableView.register(BookCell.defaultNib(), forCellReuseIdentifier: R.reuseIdentifier.bookCell.identifier)

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshGetLibrary(_:)), for: .valueChanged)
    }
    
    @objc private func refreshGetLibrary(_ sender: Any) {
        getLibrary()
    }
    
    private func setupTabBarItems() {
        self.tabBarView.set(
            items: [
                TabBarView.Item(title: NSLocalizedString("ЧИТАЮ", comment: "tabbar")),
                TabBarView.Item(title: NSLocalizedString("ИЗБРАННОЕ", comment: "tabbar")),
                TabBarView.Item(title: NSLocalizedString("АРХИВ", comment: "tabbar"))
            ]
        )
    }

}

extension MainViewController {
    
    private func getLibrary() {
        showHud()
        viewModel?.getLibrary(completion: { [weak self] (data) in
            self?.filterLibrary(data)
        })

        viewModel?.errorString
            .asObservable()
            .subscribe(onNext: { [weak self] errorStr in
                self?.hideHud()
                self?.refreshControl.endRefreshing()
                if (errorStr != "") {
                    print("error")
                }
        }).disposed(by: disposeBag)
    }
    
    private func filterLibrary(_ data: [Library]) {
        readingLibrary = data.filter({ $0.libInfo?.type == 0 })
        archiveLibrary = data.filter({ $0.libInfo?.type == 1 })
        favoritesLibrary = data.filter({ $0.libInfo?.type == 2 })
        
        listModeType(self.listMode, animated: true)
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

}

extension MainViewController: TabBarViewDelegate {
    
    func tabBarView(_ tabbBarView: TabBarView, didSelect index: Int) {
        let mode = ListMode(rawValue: index)!
        self.listMode = mode
        listModeType(mode, animated: true)
    }
    
    func listModeType(_ listMode: ListMode, animated: Bool) {
        libraries = []
        self.listMode = listMode
        switch listMode {
        case .reading:
            libraries = readingLibrary
        case .archive:
            libraries = archiveLibrary
        case .favorites:
            libraries = favoritesLibrary
        }

        tableView.reloadData()
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.bookCell.identifier, for: indexPath) as! BookCell
        
        let item = libraries[indexPath.row]
        cell.setModel(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = R.storyboard.main.detailsViewController() else { return }
        vc.bookId = libraries[indexPath.row].book?.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
