//
//  ViewController.swift
//  Brute Force for DVWA
//
//  Created by Леонид Лукашевич on 14.11.2021.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var aaa: NSTextField!
    
    @IBAction func getTapped(_ sender: NSButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if let response = response {
                print(response)
            }
            
            guard let data = data else { return }
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    @IBAction func postTapped(_ sender: NSButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        let parameters = ["Username": "hutr0", "Message": "Fuck u!"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            
            guard let data = data else { return }
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    @IBAction func getDVWATapped(_ sender: NSButton) {
        guard let url = URL(string: "http://localhost/dvwa/vulnerabilities/brute/?username=1&password=1&Login=Login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("security=low; PHPSESSID=gvcpg0286vsfnal862hl4uks4j", forHTTPHeaderField: "Cookie")
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }

            guard let data = data, let html = String(data: data, encoding: .utf8) else { return }
            print(html)
        }.resume()
    }
}
