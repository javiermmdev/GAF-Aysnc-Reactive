import UIKit
import Combine

// TableViewController to display a list of hero transformations
class TransformationsTableViewController: UITableViewController {

    // ViewModel responsible for managing the transformation data
    private var viewModel: TransformationsViewModel
    // Set to store Combine subscriptions for reactive binding
    var subscriptions = Set<AnyCancellable>()
    
    // Custom initializer with dependency injection
    // Parameters:
    // - viewModel: The ViewModel managing transformations logic and data
    init(viewModel: TransformationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil) // Calls the superclass initializer
    }
    
    // Required initializer for using storyboards (not implemented here)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Lifecycle method called after the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register a custom cell for use in the table view
        tableView.register(UINib(nibName: "HerosTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // Set the title of the view
        self.title = NSLocalizedString("TransformationList", comment: "Title for the transformations list")
        
        // Bind the UI to the ViewModel
        self.bindingUI()
    }
    
    // Private method to bind the ViewModel's data to the table view
    private func bindingUI() {
        self.viewModel.$transformationsData
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink { [weak self] _ in
                self?.tableView.reloadData() // Reload the table view when data changes
            }
            .store(in: &subscriptions) // Store the subscription
    }

    // MARK: - Table view data source

    // Number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Single section for all transformations
    }

    // Number of rows in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.transformationsData.count // Number of transformations
    }
    
    // Configure each cell in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HerosTableViewCell
        
        // Get the transformation data for the current row
        let transformation = self.viewModel.transformationsData[indexPath.row]
        cell.title.text = transformation.name // Set the transformation name
        if let url = URL(string: transformation.photo) {
            cell.photo.loadImageRemote(url: url) // Load the transformation photo asynchronously
        }
        return cell
    }
    
    // Set the height for each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // Fixed row height
    }
    
    // Handle row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transformation = self.viewModel.transformationsData[indexPath.row] // Get the selected transformation
        
        // Log the name of the selected transformation
        NSLog("Transformation tap => \(transformation.name)")
    }
}
