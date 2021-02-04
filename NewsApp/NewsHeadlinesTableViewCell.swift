//
//  NewsHeadlinesTableViewCell.swift
//  NewsApp
//
//  Created by Mac - 1 on 01/02/21.
//

import UIKit

class NewsHeadlinesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDescription: UITextView!
    @IBOutlet weak var newsAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
