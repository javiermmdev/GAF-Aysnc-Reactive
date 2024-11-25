import UIKit
import Combine

final class DetailHeroViewController: UIViewController {
    var hero: HerosModel?
    private var viewModel: HeroDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let transformationsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Transformaciones", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Oculto por defecto
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let hero = hero else { return }
        self.viewModel = HeroDetailViewModel(hero: hero)
        self.view.backgroundColor = .white
        setupUI()
        bindViewModel()
        loadHeroData()
        Task {
            await viewModel.fetchTransformations()
        }
    }

    private func setupUI() {
        // Agregar subviews
        view.addSubview(photoImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(transformationsButton)

        // Configurar Auto Layout
        NSLayoutConstraint.activate([
            // Imagen
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            photoImageView.heightAnchor.constraint(equalToConstant: 200),

            // Nombre
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Descripción
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Botón
            transformationsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            transformationsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.$isTransformationsButtonVisible
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                self?.transformationsButton.isHidden = !isVisible
            }
            .store(in: &cancellables)
    }

    private func loadHeroData() {
        let heroDetails = viewModel.getHeroDetails()
        nameLabel.text = heroDetails.name
        descriptionLabel.text = heroDetails.description
        if let url = URL(string: heroDetails.photo) {
            photoImageView.loadImageRemote(url: url)
        }
    }
}
