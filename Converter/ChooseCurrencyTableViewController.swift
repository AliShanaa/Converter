import UIKit

protocol ChooseCurrencyTableViewControllerDelegate {
    var converter: Converter! { get }
}

class ChooseCurrencyTableViewController: UITableViewController {

    // MARK: Properties

    var converter: Converter!

    var model: ChooseCurrencyModel!

    var delegate: ChooseCurrencyTableViewControllerDelegate?

    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: UITableViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        converter = delegate!.converter

        searchBar.delegate = self

        model = ChooseCurrencyModel(currencies: converter.filteredCurrencies)
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.filteredCurrencies.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCurrencyCell", for: indexPath) as! CurrencyTableViewCell

        cell.delegateForCheckBoxActions = self

        let currency = model.filteredCurrencies[indexPath.row]

        cell.name.text = currency.iso4217
        cell.icon.image = UIImage(named: currency.country.lowercased())

        cell.country.text = currency.country.capitalized

        cell.checkbox.on = currency.on
        cell.checkbox.onAnimationType = .fill
        cell.checkbox.offAnimationType = .fill

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        makeSearchBarOk()

        let cell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell

        cell.checkbox.setOn(!cell.checkbox.on, animated: true)
        cell.checkboxValueDidChange()

        updateTableView()
    }
}

extension ChooseCurrencyTableViewController: CurrencyCellDelegateForCheckBox {
    func add(currency: String) {
        converter.addCurrency(with: currency)
        model.add(with: currency)
    }

    func remove(currency: String) {
        converter.deleteCurrency(with: currency)
        model.delete(with: currency)
    }

    func updateTableView() {
        model.filter(text: searchBar.text ?? "")
    }

    func makeSearchBarOk() {
        searchBar.resignFirstResponder()
    }
}

extension ChooseCurrencyTableViewController: UISearchBarDelegate  {

    //MARK: - UISearchBar Methods

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()

        model.filter(text: "")
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.filter(text: searchText)
        tableView.reloadData()
    }
}
