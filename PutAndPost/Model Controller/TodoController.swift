//
//  TodoController.swift
//  PutAndPost
//
//  Created by Seschwan on 5/27/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation

enum PushMethod: String {
    case post = "POST"
    case put = "PUT"
    
}

private let baseURL = URL(string: "")!

class TodoController {
    private(set) var todos: [Todo] = []
    
    func createTodo(with title: String) -> Todo {
        let todo = Todo(title: title)
        return todo
    }
    
    func push(todo: Todo, using method: PushMethod, completion: @escaping (Error?) -> Void) {
        var url = baseURL
        
        if method == .put {
            url.appendPathComponent(todo.identifier)
        }
        
        url.appendPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Encode data in to JSON
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(todo)
            
        } catch {
            print(error)
            completion(error)
            return
        }
        
        
        
        // Send JSON to Firebase
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func fetchTodos(completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        // Fetch data from Firebase
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedDictionary = try jsonDecoder.decode([String: Todo].self, from: data)
                let todos = Array(decodedDictionary.values)
                self.todos = todos
                completion(nil)
            } catch {
                print("Error decoding recieved data: \(error)")
                completion(error)
                return
            }
        }.resume()
        
    }
}
