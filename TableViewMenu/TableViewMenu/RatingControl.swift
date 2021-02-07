//
//  RatingControl.swift
//  TableViewMenu
//
//  Created by Artur on 07.02.2021.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons: [UIButton] = []
    
    var rating = 0 {
        didSet {
            self.updateButtonSelectionStates()
        }
    }
    
    @IBInspectable
    var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            self.setupButtons()
        }
    }
    
    @IBInspectable
    var starCount: Int = 5 {
        didSet {
            self.setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButtons()
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        
        // clear any existing buttons
        for button in self.ratingButtons {
            self.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        self.ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0 ..< self.starCount {
            
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: self.starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: self.starSize.width).isActive = true
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            button.addTarget(self, action: #selector(self.ratingButtonTapped), for: .touchUpInside)
            
            // Add the button to the stack
            self.addArrangedSubview(button)
            
            // Add the new button to the rating button array
            self.ratingButtons.append(button)
        }
        self.updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = self.ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(self.ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == self.rating {
            // If the selected star represents the current rating, reset the rating to 0.
            self.rating = 0
        } else {
            // Otherwise set the rating to the selected star
            self.rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in self.ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < self.rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if self.rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            
            switch self.rating {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(self.rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
