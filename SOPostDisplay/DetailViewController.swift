//
//  DetailViewController.swift
//  
//
//  Created by Tom on 4/22/19.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    // MARK: - Attributes
    var question: Question? = nil
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answeredLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var ownerImg: UIImageView!

    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestion()
    }
    
    func loadQuestion() {
        titleLabel.text = question!.title
        if question!.is_answered {
            answeredLabel.text = "Answered: ✓"
        } else {
            answeredLabel.text = "Answered: ✕"
        }
        var tags = ""
        for tag in question!.tags {
            tags.append(", \(tag)")
        }
        tagsLabel.text = "Tags: \(tags.dropFirst(2))"
        ownerLabel.text = question!.owner.display_name
        let rep: Int = question?.owner.reputation ?? 0
        repLabel.text = "Reputation: \(rep)"
        if let urlString = question!.owner.profile_image,
            let url = URL(string: urlString) {
            ownerImg.isHidden = false
            ownerImg.sd_setImage(with: url, completed: nil)
        } else {
            ownerImg.isHidden = true
        }
        
    }
    
    @IBAction func openQuestion(_ sender: Any) {
        guard let link = question?.link,
            let url = URL(string: link) else {return}
        
        UIApplication.shared.open(url)
    }

    @IBAction func openOwner(_ sender: Any) {
        guard let link = question?.owner.link,
        let url = URL(string: link) else {return}
        
        UIApplication.shared.open(url)
    }
}
