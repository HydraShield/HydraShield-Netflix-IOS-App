//
//  APICaller.swift
//  Netflix Clone
//
//  Created by PethaniSmit on 19/09/22.
//

import Foundation

struct Constants {
    static let API_Key = "c87ca98c52b1f60b82de782dd265c738"
    static let baseURl = "https://api.themoviedb.org"
}

enum APIError: Error{
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURl)/3/trending/all/day?api_key=\(Constants.API_Key)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do{
                let result = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(result.results))
                
            }catch{
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
}
