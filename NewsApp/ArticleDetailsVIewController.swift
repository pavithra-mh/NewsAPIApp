//
//  ArticleDetailsVIewController.swift
//  NewsApp
//
//  Created by Mac - 1 on 04/02/21.
//

import UIKit
import WebKit

class ArticleDetailsVIewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var ArticleDetailsWebView: WKWebView!
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ArticleDetailsWebView.uiDelegate = self
        let myURL = URL(string:urlString)
        let myRequest = URLRequest(url: myURL!)
        self.ArticleDetailsWebView.load(myRequest)
    }
}
