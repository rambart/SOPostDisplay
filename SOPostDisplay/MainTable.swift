//
//  MainTable.swift
//  SOPostDisplay
//
//  Created by Tom on 4/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit
import SDWebImage

class MainTable: UIViewController {
    
    var url = "https://api.stackexchange.com/2.2/questions?order=asc&site=stackoverflow"
    var questions = [Question]()
    private let refreshControl = UIRefreshControl()
    var nothing: Any? = nil
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshQuestionData), for: .valueChanged)
        
        questions = fetchQuestions(url)
        table.reloadData()
        print(questions.count)
    }
    
    @objc func refreshQuestionData() {
        DispatchQueue.main.async {
            self.questions = fetchQuestions(self.url)
            
            self.table.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestion" {
            guard let question = sender as? Question else {return}
            let detail = segue.destination as! DetailViewController
            detail.question = question
        }
    }

    

}

extension MainTable: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        let qstn = questions[indexPath.row]
        if qstn.is_answered {
            cell.answeredLabel.text = "✓"
            cell.answeredLabel.textColor = UIColor(displayP3Red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
        } else {
            cell.answeredLabel.text = "✕"
            cell.answeredLabel.textColor = UIColor(displayP3Red: 0.75, green: 0.0, blue: 0.0, alpha: 1.0)
        }
        cell.titleLabel.text = qstn.title
        var tags = ""
        for tag in qstn.tags {
            tags.append(", \(tag)")
        }
        cell.tagsLabel.text = "Tags: \(tags.dropFirst(2))"
        cell.ownerLabel.text =  qstn.owner.display_name
        
        if let imgURLString = qstn.owner.profile_image,
        let imgURl = URL(string: imgURLString){
            cell.ownerImg.isHidden = false
            cell.ownerImg.sd_setImage(with: imgURl, placeholderImage: UIImage())
        } else {
            cell.ownerImg.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showQuestion", sender: questions[indexPath.row])
    }
    
}

class QuestionCell: UITableViewCell {
    @IBOutlet weak var answeredLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var ownerImg: UIImageView!
}
