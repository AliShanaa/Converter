//
//  TableViewController.swift
//  CurrencyConverter
//
//  Created by Ali on 3/29/17.
//  Copyright © 2017 Ali. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, ChooseCurrencyTableViewControllerDelegate {
    
    // MARK: - Properties
    
    var converter: Converter!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.tintColor = .white
        
        converter = Converter(source: "https://openexchangerates.org/api/latest.json?app_id=e999ef8c12de48039b1c1ceb2f9bbfc6")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return converter.numberOfCurrencies
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CurrencyTableViewCell
        cell.delegate = self
        
        let data = converter.get(with: indexPath.row)
        cell.name.text = data.iso4217
        cell.value.text = data.number
        cell.icon.image = UIImage(named: data.country.lowercased())
        cell.country.text = data.country.capitalized
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    /// Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
            converter.deleteCurrency(with: cell.name.text!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        converter.filter(with: searchBar.text ?? "")
        tableView.reloadData()
        
        if segue.identifier == "addCurrency"{
            print(segue.destination)
            if let ChooseCurrencyController = segue.destination as? ChooseCurrencyTableViewController {
                ChooseCurrencyController.delegate = self
            }
        }
    }
}

extension TableViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        converter.filter(with: searchBar.text ?? "")
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        converter.filter(with: searchText)
        tableView.reloadData()
    }
}

extension TableViewController: CurrencyCellDelegate {
    
    //MARK: - Currency Cell Methods
    
    func update(sender name: String, with newValue: Double) {
        
        converter.convert(str: name, value: newValue)
        
        converter.filter(with: searchBar.text ?? "")
        
        for cell in tableView.visibleCells as! [CurrencyTableViewCell] {
            cell.value.text = try! converter.getRate(with: cell.name.text!)
        }
    }
}
