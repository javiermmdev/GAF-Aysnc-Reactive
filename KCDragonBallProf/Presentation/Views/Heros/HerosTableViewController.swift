import UIKit
import Combine

// ViewController for displaying a list of heroes in a table view
class HerosTableViewController: UITableViewController {

    // Dependency to manage application state
    private var appState: AppState?
    // ViewModel to handle hero-related logic and data
    private var viewModel: HerosViewModel
    // Set to manage Combine subscriptions
    var suscriptions = Set<AnyCancellable>()
    
    // Custom initializer with dependency injection
    // Parameters:
    // - appState: The application state, used for handling global state changes
    // - viewModel: The ViewModel providing hero data and logic
    init(appState: AppState, viewModel: HerosViewModel) {
        self.appState = appState
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // Required initializer for using storyboards (not implemented here)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Lifecycle method called after the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom table view cell
        tableView.register(UINib(nibName: "HerosTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // Add a "close session" button to the navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSession))
        
        // Set the title of the screen
        self.title = NSLocalizedString("HeroList", comment: "Title for the hero list")
        
        // Bind the UI to the ViewModel's data
        self.bindingUI()
    }
    
    // Action to handle "close session" button tap
    @objc func closeSession() {
        NSLog("Tap in close session button") // Log the action
        self.appState?.closeSessionUser() // Notify AppState to close the session
    }
    
    // Private method to bind the ViewModel's hero data to the table view
    private func bindingUI() {
        self.viewModel.$herosData
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink { data in
                self.tableView.reloadData() // Reload the table view with new data
            }
            .store(in: &suscriptions) // Store the subscription
    }

    // MARK: - Table view data source

    // Number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Number of rows in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.herosData.count // Number of heroes
    }
    
    // Configure each cell in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HerosTableViewCell
        
        let hero = self.viewModel.herosData[indexPath.row] // Get the hero for the current row
        cell.title.text = hero.name // Set the hero's name
        cell.photo.loadImageRemote(url: URL(string: hero.photo)!) // Load the hero's photo asynchronously
        return cell
    }
    
    // Set the height for each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // Fixed height for rows
    }
    
    // Handle row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = self.viewModel.herosData[indexPath.row] // Get the selected hero
        
        // Create the detail view controller and pass the selected hero
        let detailVC = DetailHeroViewController()
        detailVC.hero = hero
        
        // Navigate to the detail view
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        NSLog("Hero tap => \(hero.name)") // Log the selected hero's name
    }
}

#Preview {
    HerosTableViewController(
        appState: AppState(loginUseCase: LoginUseCaseFake()),
        viewModel: HerosViewModel(useCase: HeroUseCaseFake()))
}
