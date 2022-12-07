//
//  ViewController.swift
//  Netflix Clone
//
//  Created by PethaniSmit on 24/08/22.
//

import UIKit

enum Section: Int{
    case TredndingMovies = 0
    case TrendingTvs = 1
    case UpcomingMovies = 2
    case Popular = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie : Movie?
    private var headerView : HeroHeaderUIView?
    
    let sectionTitles = ["Trending Movies", "Trending Tvs", "Populer", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configNavbar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width ,height: 500))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        
    }
    
    private func configureHeroHeaderView(){
        APICaller.shared.getTrendingTvs{ result in
            switch result{
            case .success(let movies):
                let selected = movies.randomElement()
                self.randomTrendingMovie = selected
                self.headerView?.configure(with: MovieViewModel(movieName: selected?.original_title ?? "", posterURL: selected?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configNavbar(){
        var image = UIImage(named: "Logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
        ]
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell
        else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section{
        case Section.TredndingMovies.rawValue:
            APICaller.shared.getTrendingMovies{ result in
                switch result{
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.TrendingTvs.rawValue:
            APICaller.shared.getTrendingTvs{ result in
                switch result{
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies{ result in
                switch result{
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.Popular.rawValue:
            APICaller.shared.getPopular{ result in
                switch result{
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.TopRated.rawValue:
            APICaller.shared.getTopRated{ result in
                switch result{
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x+20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLatter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffSet
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}


extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel){
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
