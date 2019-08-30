//
//  MasuharaListViewController.swift
//  MasuharaQuote
//
//  Created by 藤田えりか on 2019/08/25.
//  Copyright © 2019 com.erica. All rights reserved.
//

import UIKit


class MasuharaListViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet var masuharaTableView: UITableView!
    var articles: [[String: Any]] = [] {
        didSet {
            masuharaTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masuharaTableView.dataSource = self
        masuharaTableView.tableFooterView = UIView()
        
        //APIのURL
        let url: URL = URL(string: "https://qiita.com/api/v2/items?page=1&query=user%3Amasuhara")!
        
        //作成
        let task: URLSessionTask  = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                let articles = json.map { (article) -> [String: Any] in
                    return article as! [String: Any]
                    
                }
                DispatchQueue.main.async() { () -> Void in
                    self.articles = articles
                    
                }
            }
            catch {
                print(error)
            }
        })
        task.resume()
        
        masuharaTableView.reloadData()
        
        UIRefreshControl()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = articles[indexPath.row]["title"] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}


