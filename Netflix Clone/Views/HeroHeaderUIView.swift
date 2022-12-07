//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by PethaniSmit on 27/08/22.
//

import UIKit

class HeroHeaderUIView: UIView {

    private let heroImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "HeroHeader")
        
        return image
    }()
    
    private let DownloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyContrain(){
        let PlayButtonContrain = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120),
        ]
        
        let DownloadButtonContrain = [
            DownloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            DownloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            DownloadButton.widthAnchor.constraint(equalToConstant: 120),
        ]
        
        NSLayoutConstraint.activate(PlayButtonContrain)
        NSLayoutConstraint.activate(DownloadButtonContrain)
    }
    
    public func configure(with model: MovieViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(DownloadButton)
        applyContrain()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
