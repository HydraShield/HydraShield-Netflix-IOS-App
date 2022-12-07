//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by PethaniSmit on 24/08/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movies: [Movie] = [Movie]()
    
    private let discoverTable : UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier:MovieTableViewCell.identifier)
        return table
    }()
    
    private let searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for Movie or Tvs"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        fetchDiscover()
        
        searchController.searchResultsUpdater = self
        
    }
    
    private func fetchDiscover(){
        APICaller.shared.getDiscover{ result in
            switch result{
            case .success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }

}


extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(with: MovieViewModel(movieName: movie.original_title ?? movie.original_name ?? "Unknown title Name", posterURL: movie.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let movieName = movie.original_title ?? movie.original_name else {
            return
        }
        
        APICaller.shared.getTrailer(with: movieName){ [weak self] result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = MoviePreviewViewController()
                    vc.configure(with: MoviePreviewViewModel(movie: movieName, trailer: videoElement, movieOverview: movie.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }
        
        APICaller.shared.search(with: query){ result in
            DispatchQueue.main.async {
                switch result{
                case .success(let movies):
                    resultController.movies = movies
                    resultController.searchResultCollectionView.reloadData()
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
}
