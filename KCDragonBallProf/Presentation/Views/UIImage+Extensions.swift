import UIKit

// Extension to UIImageView for loading images from a remote URL
extension UIImageView {
    // Function to load an image asynchronously from a URL
    // Parameters:
    // - url: The URL from which the image will be loaded
    func loadImageRemote(url: URL) {
        // Perform the image loading task on a background thread
        DispatchQueue.global().async { [weak self] in
            // Attempt to fetch data from the given URL
            if let data = try? Data(contentsOf: url) {
                // Attempt to create a UIImage from the fetched data
                if let image = UIImage(data: data) {
                    // Update the UIImageView's image on the main thread
                    DispatchQueue.main.async {
                        self?.image = image // Safely assign the loaded image
                    }
                }
            }
        }
    }
}
