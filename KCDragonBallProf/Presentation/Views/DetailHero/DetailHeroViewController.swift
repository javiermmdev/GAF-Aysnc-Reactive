import UIKit
import Combine

// ViewController for displaying detailed information about a specific hero
final class DetailHeroViewController: UIViewController {
    
    // The hero model containing details to be displayed
    var hero: HerosModel?
    // ViewModel responsible for managing hero-related logic and state
    private var viewModel: HeroDetailViewModel!
    // Set to manage Combine subscriptions for reactive updates
    private var cancellables = Set<AnyCancellable>()
    
    // ImageView to display the hero's photo
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Aspect fit to maintain image ratio
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Label to display the hero's name
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24) // Bold font for emphasis
        label.textAlignment = .center // Center alignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Label to display the hero's description
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16) // Standard font size
        label.textAlignment = .justified // Justified alignment for readability
        label.numberOfLines = 0 // Allow multiple lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Button to show hero transformations
    private let transformationsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Transformations", comment: "Button title to show transformations"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Bold font for visibility
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Hidden by default
        return button
    }()
    
    // Lifecycle method called after the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let hero = hero else { return } // Ensure hero data exists
        self.viewModel = HeroDetailViewModel(hero: hero) // Initialize the ViewModel
        self.view.backgroundColor = .white // Set the background color
        setupUI() // Configure the UI elements
        bindViewModel() // Bind the ViewModel to the UI
        loadHeroData() // Populate the UI with hero data
        setupActions() // Configure button actions
        Task {
            await viewModel.fetchTransformations() // Fetch transformations asynchronously
        }
    }
    
    // Function to configure and set up the UI elements
    private func setupUI() {
        // Add the scrollView to the main view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView) // Add contentView to the scrollView

        // Add UI elements to the contentView
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(transformationsButton)

        // Configure Auto Layout constraints for scrollView and contentView
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

        // Configure Auto Layout constraints for the elements in contentView
        NSLayoutConstraint.activate([
            // Photo ImageView constraints
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            photoImageView.heightAnchor.constraint(equalToConstant: 200),

            // Name Label constraints
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Description Label constraints
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Transformations Button constraints
            transformationsButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            transformationsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            transformationsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    // Function to bind ViewModel properties to the UI
    private func bindViewModel() {
        viewModel.$isTransformationsButtonVisible
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink { [weak self] isVisible in
                self?.transformationsButton.isHidden = !isVisible // Update button visibility
            }
            .store(in: &cancellables) // Store the subscription
    }

    // Function to load hero details into the UI
    private func loadHeroData() {
        let heroDetails = viewModel.getHeroDetails() // Get hero details from ViewModel
        nameLabel.text = heroDetails.name // Set the hero's name
        descriptionLabel.text = heroDetails.description // Set the hero's description
        if let url = URL(string: heroDetails.photo) {
            photoImageView.loadImageRemote(url: url) // Load the hero's photo asynchronously
        }
    }
    
    // Function to configure button actions
    private func setupActions() {
        transformationsButton.addTarget(self, action: #selector(didTapTransformationsButton), for: .touchUpInside)
    }

    // Action for when the Transformations button is tapped
    @objc func didTapTransformationsButton() {
        guard let heroId = hero?.id else {
            print("Hero ID is missing") // Log error if hero ID is missing
            return
        }
        
        // Create the ViewModel for Transformations
        let transformationsViewModel = TransformationsViewModel()
        
        // Create the TransformationsTableViewController
        let transformationsVC = TransformationsTableViewController(viewModel: transformationsViewModel)
        
        // Navigate to TransformationsTableViewController
        self.navigationController?.pushViewController(transformationsVC, animated: true)
        
        // Fetch transformations for the current hero
        Task {
            await transformationsViewModel.fetchTransformations(heroName: heroId.uuidString)
        }
    }
    
    // UIScrollView to enable scrolling for content
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // Content view inside the scroll view to hold the elements
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
