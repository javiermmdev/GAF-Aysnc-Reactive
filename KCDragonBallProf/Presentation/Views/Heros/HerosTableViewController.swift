import UIKit
import Combine

class HerosTableViewController: UITableViewController {

    private var appState: AppState?
    private var viewModel: HerosViewModel
    var suscriptions = Set<AnyCancellable>()
    
    init(appState: AppState, viewModel: HerosViewModel) {
        self.appState = appState
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HerosTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSession))
        self.title = NSLocalizedString("HeroList", comment: "Título para la lista de héroes")
        self.bindingUI()
    }
    
    @objc func closeSession() {
        NSLog("Tap in close session button")
        self.appState?.closeSessionUser()
    }
    
    private func bindingUI() {
        self.viewModel.$herosData
            .receive(on: DispatchQueue.main)
            .sink{ data in
                self.tableView.reloadData()
            }
            .store(in: &suscriptions)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.herosData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HerosTableViewCell
        
        let hero = self.viewModel.herosData[indexPath.row]
        cell.title.text = hero.name
        cell.photo.loadImageRemote(url: URL(string: hero.photo)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = self.viewModel.herosData[indexPath.row]
        
        // Crear la nueva vista y pasarle el héroe
        let detailVC = DetailHeroViewController()
        detailVC.hero = hero
        
        // Navegar a la nueva vista
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        NSLog("Hero tap => \(hero.name)")
    }
}

#Preview {
    HerosTableViewController(
        appState: AppState(loginUseCase: LoginUseCaseFake()),
        viewModel: HerosViewModel(useCase: HeroUseCaseFake()))
}
