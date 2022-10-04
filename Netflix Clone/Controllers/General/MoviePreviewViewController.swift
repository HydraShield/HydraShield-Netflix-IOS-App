//
//  MoviePreviewViewController.swift
//  Netflix Clone
//
//  Created by PethaniSmit on 03/10/22.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController {
    
    private let webView: WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    private let movieLable: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 22, weight: .bold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Harry Potter"
        return lable
    }()
    
    private let overviewLable: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 18, weight: .regular)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        lable.text = "Harry Potter is Best for Magic by JK Rollins"
        return lable
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        view.addSubview(webView)
        view.addSubview(movieLable)
        view.addSubview(overviewLable)
        view.addSubview(downloadButton)
        
        configureConstraints()
    }
    
    private func configureConstraints(){
        let webViewConstraint = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250),
        ]
        
        let movieLableConstraint = [
            movieLable.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            movieLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ]
        
        let overviewConstraint = [
            overviewLable.topAnchor.constraint(equalTo: movieLable.bottomAnchor, constant: 15),
            overviewLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ]
        
        let downloadConstraint = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLable.topAnchor, constant: 30),
            downloadButton.widthAnchor.constraint(equalToConstant: 150),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
        ]
        
        NSLayoutConstraint.activate(webViewConstraint)
        NSLayoutConstraint.activate(movieLableConstraint)
        NSLayoutConstraint.activate(overviewConstraint)
        NSLayoutConstraint.activate(downloadConstraint)
    }
    
    func configure(with model: MoviePreviewViewModel){
        movieLable.text = model.movie
        overviewLable.text = model.movieOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.trailer.id.videoId)") else {
            return
        }
        
        print(url)
        webView.load(URLRequest(url: url))
    }

}
