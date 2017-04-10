//
//  ChooseCurrencyTableViewController.swift
//  CurrencyConverter
//
//  Created by Ali on 4/7/17.
//  Copyright © 2017 Ali. All rights reserved.
//

import UIKit

protocol ChooseCurrencyTableViewControllerDelegate {
    var converter: Converter! { get }
}

class ChooseCurrencyTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var filteredData = [(country: String, iso4217: String, on: Bool)]()
    
    var converter: Converter!
    
    var delegate: ChooseCurrencyTableViewControllerDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: UITableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        converter = delegate!.converter
        
        searchBar.delegate = self
        searchBar.tintColor = .white
        
        filteredData = converter.get()
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCurrencyCell", for: indexPath) as! CurrencyTableViewCell
        
        cell.delegateForCheckBoxActions = self
        
        cell.name.text = filteredData[indexPath.row].iso4217
        cell.icon.image = UIImage(named: filteredData[indexPath.row].country.lowercased())
        
        cell.country.text = filteredData[indexPath.row].country.capitalized
        cell.checkbox.on = filteredData[indexPath.row].on
        
        cell.checkbox.onAnimationType = .fill
        cell.checkbox.offAnimationType = .fill
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateView()
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
        
        cell.checkbox.setOn(!cell.checkbox.on, animated: true)
        cell.checkboxValueDidChange()
    }
    
    func updateView() {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}

extension ChooseCurrencyTableViewController: CurrencyCellDelegateForCheckBox {
    func add(currency: String) {
        converter.addCurrency(with: currency)
    }
    
    func remove(currency: String) {
        converter.deleteCurrency(with: currency)
    }
}

extension ChooseCurrencyTableViewController: UISearchBarDelegate  {
    
    //MARK: - UISearchBar Methods
    
    func filter(text: String) {
        filteredData = text.isEmpty ? converter.get() : converter.get().filter {
            let isISO4217 = $0.iso4217.range(of: text.uppercased()) != nil
            let hasSearchedText = $0.country.range(of: text, options: .caseInsensitive,
                                                   range: nil, locale: nil) != nil
            return isISO4217 || hasSearchedText
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        filter(text: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(text: searchText)
    }
}

