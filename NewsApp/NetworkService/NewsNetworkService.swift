//
//  NewsNetworkService.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 17/04/25.
//

import Foundation

struct NewsResponse: Decodable {
    let results: [NewsItem]
}

struct NewsItem: Codable {
    let article_id: String
    let title: String?
    let description: String?
    let link: String?
    let pubDate: String?
    let image_url: String?
    let creator: [String]?
}

class NewsNetworkService {
    
    static let shared = NewsNetworkService()
    private let apiKey = "pub_80924d6a4eba1c09c2990219ac862fb2ff2f8"

    func searchNews(query: String, completion: @escaping ([NewsItem]) -> Void) {
        let urlString = "https://newsdata.io/api/1/news?apikey=\(apiKey)&language=ru&category=top&q=\(query)"
        
        guard let url = URL(string: urlString) else {
            print("Неверный URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Ответ от API: \(jsonString)")
                }
                
                let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.results)
                }
            } catch {
                print("Ошибка парсинга: \(error)")
            }
        }
        task.resume()
    }
    
    func fetchNews(page: Int, completion: @escaping ([NewsItem]) -> Void) {
        let urlString = "https://newsdata.io/api/1/news?apikey=\(apiKey)&language=ru&category=top"
        
        guard let url = URL(string: urlString) else {
            print("Неверный URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Ответ от API: \(jsonString)")
                }
                
                let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.results)
                }
            } catch {
                print("Ошибка парсинга: \(error)")
            }
        }
        task.resume()
    }
}
