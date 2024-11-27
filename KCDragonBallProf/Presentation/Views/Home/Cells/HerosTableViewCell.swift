import UIKit

// Custom UITableViewCell subclass for displaying hero information
class HerosTableViewCell: UITableViewCell {

    // IBOutlet for the UIImageView to display the hero's photo
    @IBOutlet weak var photo: UIImageView!
    // IBOutlet for the UILabel to display the hero's name or title
    @IBOutlet weak var title: UILabel!
    
    // Lifecycle method called when the cell is loaded from the nib or storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional setup after the cell is loaded can be added here
    }

    // Lifecycle method to handle the cell's selection state
    // Parameters:
    // - selected: A Boolean indicating whether the cell is selected
    // - animated: A Boolean indicating whether the selection change should be animated
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state if needed
    }
}
