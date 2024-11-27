
import UIKit
import Combine

class TransformationsTableViewController: UITableViewController {

    private var viewModel: TransformationsViewModel
    var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: TransformationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HerosTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.title = NSLocalizedString("TransformationList", comment: "Título para la lista de transformaciones")
        self.bindingUI()
    }
    
    private func bindingUI() {
        self.viewModel.$transformationsData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.transformationsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HerosTableViewCell
        
        let transformation = self.viewModel.transformationsData[indexPath.row]
        cell.title.text = transformation.name
        if let url = URL(string: transformation.photo) {
            cell.photo.loadImageRemote(url: url)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transformation = self.viewModel.transformationsData[indexPath.row]
        
        // Log cuando se selecciona una transformación
        NSLog("Transformation tap => \(transformation.name)")
    }
}
