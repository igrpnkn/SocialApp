//
//  NewsTableViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 18.10.2020.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    private let activityIndicator = UIActivityIndicatorView()
    
    private var newsFeed: [News]? = []
    private var newsFactory = NewsFactory()
    private let newsCellFactory = NewsCellFactory()
    private var newsNextFrom = ""
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.prefetchDataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        setupRefreshControl()
        downloadNews(startTime: Int(Date().timeIntervalSince1970), fromNext: newsNextFrom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoading {
            startActivityIndicator()
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return newsFeed?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 14))
        sectionHeaderView.backgroundColor = .systemGray5
        return sectionHeaderView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = newsFeed?[indexPath.section]
        switch indexPath.row {
        case 0: // Header
            return newsCellFactory.buildCell(for: .header, news, tableView, indexPath)
        case 1: // Text
            return newsCellFactory.buildCell(for: .text, news, tableView, indexPath)
        case 2: // Photos
            return newsCellFactory.buildCell(for: .media, news, tableView, indexPath)
        case 3: // Footer
            return newsCellFactory.buildCell(for: .footer, news, tableView, indexPath)
        default:
            // Probably will never happens
            print("\nINFO: Admin was drunk o_O\n")
            return newsCellFactory.buildCell(for: .stock, news, tableView, indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            if 0 == newsFeed?[indexPath.section].photos?.count ?? 0 {
                return 0
            } else if 1 == newsFeed?[indexPath.section].photos?.count ?? 0 {
                return tableView.frame.width
            } else {
                return tableView.frame.width/2
            }
        default:
            return tableView.estimatedRowHeight
        }
    }
    
    @IBAction private func likeButtonPressed(_ sender: UIButton) {
        print("Button LIKE in \(sender.tag) section of NEWSFEED has been pressed!")
        if 1 == newsFeed?[sender.tag].liked ?? 0 {
            print("Post is being disliked!")
            newsFeed?[sender.tag].likeCount! -= 1
            newsFeed?[sender.tag].liked = 0
            self.newsTableView.reloadData()
        } else {
            print("Post is being liked!")
            newsFeed?[sender.tag].likeCount! += 1
            newsFeed?[sender.tag].liked = 1
            self.newsTableView.reloadData()
        }
    }
    

}

extension NewsTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        if maxSection > (newsFeed ?? []).count-2, !isLoading {
            isLoading = true
            NetworkManager.newsfeedGet(for: UserSession.instance.userId!, nextFrom: newsNextFrom, completion: { response in
                guard let response = response,
                      let posts = response.items,
                      let nextFrom = response.next_from
                else {
                    print("\nINFO: ERROR - While getting respone objects in \(#function)\n")
                    return
                }
                self.newsNextFrom = nextFrom
                print("\nINFO: \(#function) has total parsed posts: \(posts.count)")
                let shownNewsCount = (self.newsFeed ?? []).count
                print("\nINFO: \(#function) has total shown posts: \(shownNewsCount)")
                self.newsFeed?.append(contentsOf: NewsFactory().buildNewsFeed(parsedJSON: response))
                print("\nINFO: \(#function) has total after adding posts: \((self.newsFeed ?? []).count)")
                let indexSetOfNewPosts = IndexSet(integersIn: shownNewsCount ..< (self.newsFeed ?? []).count)
                print("\nINFO: \(#function) has added posts sections set: \((self.newsFeed ?? []).count)")
                self.newsTableView.performBatchUpdates({
                    self.newsTableView.insertSections(indexSetOfNewPosts, with: .automatic)
                }, completion: nil)
                self.isLoading = false
                self.downloadMedia()
            })
        }
    }
        
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("\nINFO: User SCROLLING was canceled...")
    }
    
}

extension NewsTableViewController {
    
    func startActivityIndicator() {
        print("\nINFO: Loading \(self.description) has begun.")
        activityIndicator.center.x = (self.navigationController?.navigationBar.center.x)!
        activityIndicator.center.y = (self.navigationController?.navigationBar.center.y)!*0.75
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.navigationController?.view.addSubview(activityIndicator)
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        isLoading = false
    }
    
    func downloadNews(startTime: Int, fromNext: String) {
        isLoading = true
        DispatchQueue.global().sync {
            NetworkManager.newsfeedGet(for: UserSession.instance.userId!, startTime: Int(Date().timeIntervalSince1970+1), nextFrom: fromNext, completion: { response in
                guard let response = response,
                      let posts = response.items
                else {
                    print("\nINFO: ERROR - While getting respone objects in \(#function)\n")
                    return
                }
                if let nextFrom = response.next_from {
                    self.newsNextFrom = nextFrom
                } else { print("\nINFO: ERROR - While getting NEXT_FROM property in \(#function), next_from = \(response.next_from ?? "")\n") }
                print("\nINFO: \(#function) has total parsed posts: \(posts.count)")
                self.biuldNewsFeed(newsFeed: response)
            })
        }
    }
    
    func biuldNewsFeed(newsFeed response: PostResponse) {
        self.newsFeed = self.newsFactory.buildNewsFeed(parsedJSON: response)
        print("\nINFO: \(#function) has total built news: \(newsFeed?.count ?? 0)")
        downloadMedia()
    }
    
    func downloadMedia() {
        DispatchQueue.global().async {
            print("\nINFO: \(#function) Starting downloading avatars.")
            for news in self.newsFeed! {
                if let avatarURL = news.avatarURL,
                   let url = URL(string: avatarURL),
                   let data = try? Data(contentsOf: url) {
                    news.avatar = data
                }
            }
            DispatchQueue.main.async {
                print("\nINFO: \(#function) Reloading data after downloading avatars.")
                self.newsTableView.reloadData()
            }
        }
        DispatchQueue.global().async {
            print("\nINFO: \(#function) Starting downloading photos for NewsFeed.")
            for news in self.newsFeed! {
//                print("\nINFO: Trying downloading photos for \(news.author ?? "") with \(news.photosURL?.count ?? 0) URLs.")
                if (news.photos?.isEmpty ?? false),
                   let urlStrings = news.photosURL {
                    for urlString in urlStrings {
                        if let url = URL(string: urlString),
                           let data = try? Data(contentsOf: url) {
//                            print("INFO: Downloaded photo from: \(url.absoluteString)")
                            news.photos?.append(data)
                        }
                    }
                }
//                print("\n\n\nINFO: Downloaded photos for \(news.author!) with \(news.photos?.count ?? 0) photos.")
            }
            DispatchQueue.main.async {
                print("\nINFO: \(#function) Reloading data after downloading photos.")
                self.newsTableView.reloadData()
                self.stopActivityIndicator()
            }
        }
        
    }
    
    override func refreshData() {
        refreshControl?.beginRefreshing()
        let mostFreshNewsDate: Int = newsFeed?.first?.time ?? Int(Date().timeIntervalSince1970)
        NetworkManager.newsfeedGet(for: UserSession.instance.userId!, startTime: mostFreshNewsDate+1, nextFrom: "") { [weak self] response in
            self?.refreshControl?.endRefreshing()
            guard let response = response else {
                print("\nINFO: ERROR - While getting respone objects in \(#function)\n")
                return
            }
            let freshNews = NewsFactory().buildNewsFeed(parsedJSON: response)
            self?.newsFeed = freshNews + (self?.newsFeed ?? [])
            self?.newsTableView.reloadData()
            self?.downloadMedia()
        }
    }
    
}
