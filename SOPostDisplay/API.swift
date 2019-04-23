//
//  API.swift
//  SOPostDisplay
//
//  Created by Tom on 4/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import Foundation
import UIKit

func fetchQuestions(_ urlString: String) -> [Question] {
    print("fetching")
    
    var qs = [Question]()
    let sem = DispatchSemaphore(value: 0)
    
    guard let url = URL(string: urlString) else { print("not URL"); return qs }
    
    sendRequest(url: url) { (questions) in
        qs = questions
        sem.signal()
        print(questions)
    }
    
    print(qs)
    sem.wait(timeout: DispatchTime.distantFuture)
    return qs
}


func sendRequest(url: URL, completion:@escaping ([Question])->()){
    
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        
        do {
            let itms = try JSONDecoder().decode(questionContainer.self, from: data)
            guard let items = itms.items else { return }
            completion(items)
        } catch let error {
            print("Caught Decoding JSON")
            print(error)
        }
        }.resume()
}



