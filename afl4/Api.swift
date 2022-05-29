//
//  Api.swift
//  afl4
//
//  Created by MacBook Pro on 29/05/22.
//

import Foundation
final class API{
    static let shared = API()
    
    struct Constants{
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=bitcoin&apiKey=41855beebf3449a99669da4062946153")
        static let searchurl = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=41855beebf3449a99669da4062946153&q="
    }
    private init(){
        
    }
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                        
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void){
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlstring = Constants.searchurl + query
        guard let url = URL(string: urlstring) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                        
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}

//models
struct APIResponse: Codable{
    let articles: [Article]
}
struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable{
    let name: String
}
