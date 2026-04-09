import UIKit
import CoreData

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let context = PersistenceController.shared.context
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Products"
        view.backgroundColor = .systemBackground
        setupTableView()
        fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts()
        tableView.reloadData()
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 80

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = products[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = product.productName ?? ""
        content.secondaryText = product.productDesc ?? ""
        content.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = content

        return cell
    }
}
