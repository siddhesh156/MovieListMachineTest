//
//  ViewController.swift
//  MovieListMachineTest
//
//  Created by siddhesh on 17/02/21.
//  Copyright © 2021 siddhesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
   
    
   
    
    @IBOutlet weak var tableViewTest: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchMovies()
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
        let url = URL(string:Global.imgUrl + movie.imgUrl)
        let data = try? Data(contentsOf: url!)
        cell.imgView.image = UIImage(data: data!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        vc.index = indexPath.row
        self.present(vc, animated: true, completion: nil)
    }
    
    func fetchMovies(){
        let apiKey = "2c0a8efe934c162f5535ff33303e70bd"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =  session.dataTask(with: request, completionHandler:{(dataOrNil, repsonse, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{print("response: \(responseDictionary)")
                    let results = responseDictionary["results"] as? [NSDictionary]
                    
                  
                    for element in results!{
                        
                        let movie = Movies.Movie(title: element.object(forKey: "original_title") as! String, synopsis: element.object(forKey: "overview") as! String, rating: element.object(forKey: "vote_average") as! NSNumber, releaseDate: element.object(forKey: "release_date") as! String, imgUrl: element.object(forKey: "poster_path") as! String, bgImgUrl: element.object(forKey: "backdrop_path") as! String)
                        Global.movies.append(movie)
                    }
                    
                   // print("movies list ", Global.movies)
                    
                   
                    self.tableViewTest.reloadData()
                    
                }
            }
            
        })
        task.resume()
    }
}

