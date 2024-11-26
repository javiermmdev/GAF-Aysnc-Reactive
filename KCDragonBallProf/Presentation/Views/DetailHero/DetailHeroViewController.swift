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
        setupActions()
        Task {
            await viewModel.fetchTransformations()
        }
    }

    private func setupUI() {
        // Añadir el scrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Añadir subviews al contentView
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(transformationsButton)

        // Configurar Auto Layout para el scrollView y el contentView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Configurar Auto Layout para los elementos dentro del contentView
        NSLayoutConstraint.activate([
            // Imagen
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            photoImageView.heightAnchor.constraint(equalToConstant: 200),

            // Nombre
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Descripción
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Botón
            transformationsButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            transformationsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            transformationsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
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
    
    private func setupActions() {
        transformationsButton.addTarget(self, action: #selector(didTapTransformationsButton), for: .touchUpInside)
    }

    @objc private func didTapTransformationsButton() {
        guard let heroId = hero?.id else {
            print("Hero ID is missing")
            return
        }
        
        // Crear el ViewModel para Transformations
        let transformationsViewModel = TransformationsViewModel()
        
        // Crear el controlador de TransformationsTableViewController
        let transformationsVC = TransformationsTableViewController(viewModel: transformationsViewModel)
        
        // Navegar a TransformationsTableViewController
        self.navigationController?.pushViewController(transformationsVC, animated: true)
        
        // Fetch transformaciones para el héroe actual
        Task {
            await transformationsViewModel.fetchTransformations(heroName: heroId.uuidString)
        }
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
