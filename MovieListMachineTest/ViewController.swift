//
//  ViewController.swift
//  MovieListMachineTest
//
//  Created by siddhesh on 17/02/21.
//  Copyright © 2021 siddhesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableViewTest: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var currentPage = 1
    var isDataLoading:Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        fetchMovies(pgNo: 1)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        print("search txt ",searchText)
        if(searchText.count>0){
            searchMovies(keyword: searchText)
        }
    }

    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Global.movies.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        let movie =  Global.movies[indexPath.row]
        
        cell.title.text = movie.title
        var url = URL(string:Global.imgUrl + movie.imgUrl)
        var data = try? Data(contentsOf: url!)
        cell.imgView.image = UIImage(data: data ?? Data())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        vc.index = indexPath.row
        self.present(vc, animated: true, completion: nil)
    }
    
    func fetchMovies(pgNo: Int){
        
        let apiKey = "2c0a8efe934c162f5535ff33303e70bd"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&page=\(pgNo)")
        let request = URLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =  session.dataTask(with: request, completionHandler:{(dataOrNil, repsonse, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{print("response: \(responseDictionary)")
                    let results = responseDictionary["results"] as? [NSDictionary]
                                     
                    Global.movies.removeAll()
                    
                  
                    for element in results!{
                        
                    let movie = Movies.Movie(title: element.object(forKey: "original_title") as? String ?? "", synopsis: element.object(forKey: "overview") as? String ?? "", rating: element.object(forKey: "vote_average") as? NSNumber ?? 0, releaseDate: element.object(forKey: "release_date") as? String ?? "", imgUrl: element.object(forKey: "poster_path") as? String ?? "", bgImgUrl: element.object(forKey: "backdrop_path") as? String ?? "")
                        Global.movies.append(movie)
                    }
                    
                   print("movies count ", Global.movies.count)
                    
                   
                    self.tableViewTest.reloadData()
                    
                }
            }
            
        })
        task.resume()
    }
    
    func searchMovies(keyword: String){
        let apiKey = "2c0a8efe934c162f5535ff33303e70bd"
        let originalString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(keyword)&page=1"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        
        let url = URL(string: urlString!)
      
        let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =  session.dataTask(with: request, completionHandler:{(dataOrNil, repsonse, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{print("response search: \(responseDictionary)")
                    let results = responseDictionary["results"] as? [NSDictionary]
                    
                    Global.movies.removeAll()
                    
                    for element in results!{
                        
                        let movie = Movies.Movie(title: element.object(forKey: "original_title") as? String ?? "", synopsis: element.object(forKey: "overview") as? String ?? "", rating: element.object(forKey: "vote_average") as? NSNumber ?? 0, releaseDate: element.object(forKey: "release_date") as? String ?? "", imgUrl: element.object(forKey: "poster_path") as? String ?? "", bgImgUrl: element.object(forKey: "backdrop_path") as? String ?? "")
                        Global.movies.append(movie)
                    }
                    
                    print("movies list count ", Global.movies.count)
                    
                    
                    self.tableViewTest.reloadData()
                    
                }
            }
            
        })
        task.resume()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((tableViewTest.contentOffset.y + tableViewTest.frame.size.height) >= tableViewTest.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.currentPage=self.currentPage+1
                fetchMovies(pgNo: self.currentPage)
            }
        }
        else if ((tableViewTest.contentOffset.y + tableViewTest.frame.size.height) <= tableViewTest.contentSize.height)
        {
            if !isDataLoading{
                if(self.currentPage>1){
                isDataLoading = true
                self.currentPage=self.currentPage-1
                fetchMovies(pgNo: self.currentPage)
                }
                print("pg no",self.currentPage)
            }
        }
        
        
    }
}

