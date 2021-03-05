//
//  ViewController.swift
//  DataFeedApp
//
//  Created by Shilpa Joy on 2021-03-03.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetList))
        navigationItem.leftBarButtonItems = [filterButton, resetButton]
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
            parse(json: data)
            } else {
                showError()
            }
        }else {
            showError()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func showCredits() {
            let ac = UIAlertController(title: "Data source", message: "These petitions come from the \nWe The People API of the Whitehouse", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(ac, animated: true)
        }
    
    @objc func filterPetitions() {
            let ac = UIAlertController(title: "Data source", message: "Search for petitions", preferredStyle: .alert)
            ac.addTextField { (textField) in
            textField.placeholder = "Search for petitions"
        }
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak ac] (_) in
            guard let textField = ac?.textFields?[0], let userText = textField.text else { return }
            print("User text: \(userText)")
            self.showPetitions(for: userText)
        }))
        self.present(ac, animated: true, completion: nil)
        }
    
    @objc func  resetList(){
        filteredPetitions = petitions
        tableView.reloadData()
    }
    
    func showPetitions(for userText: String){
        
        filteredPetitions = filteredPetitions.filter { $0.title.contains(userText) }
                print(filteredPetitions)
        tableView.reloadData()
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonpetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonpetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let petition = petitions[indexPath.row]
       let petition = filteredPetitions[indexPath.row]
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

