//
//  DetailScreenViewController.swift
//  MovieListMachineTest
//
//  Created by siddhesh on 17/02/21.
//  Copyright © 2021 siddhesh. All rights reserved.
//

import UIKit

class DetailScreenViewController: UIViewController {

    var index = 0
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var synopsis: UITextView!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      self.mainTitle.text = Global.movies[index].title
      self.synopsis.text = Global.movies[index].synopsis
      self.rating.text = "\(Global.movies[index].rating)"
      self.releaseDate.text = Global.movies[index].releaseDate
      let url = URL(string:Global.imgUrl + Global.movies[index].bgImgUrl)
      let data = try? Data(contentsOf: url!)
      movieImg.image = UIImage(data: data!)
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
