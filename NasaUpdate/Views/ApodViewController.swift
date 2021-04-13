//
//  ViewController.swift
//  NasaUpdate
//
//  Created by Utkarsh Upadhyay (BLR GSS) on 10/04/21.
//

import UIKit

class ApodViewController: UIViewController {

    var viewModel: ApodViewModelContract?

    // MARK: - IBOutels

    @IBOutlet weak var apodImageView: UIImageView!

    @IBOutlet weak var detailTextView: UITextView!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        detailTextView.isEditable = false

        //Instantiate view model
        viewModel = ApodViewModel()

        handleApodResponse()
        handleImageResponse()

        //Call method to get today data
        viewModel?.getAstronomyPictureOfTheDay()
    }


    // MARK: - Private Methods
    
    private func handleApodResponse() {
        viewModel?.dataHandler = { [weak self] (data, error) in
            DispatchQueue.main.async {
                if let data = data {
                    self?.navigationItem.title = data.title
                    self?.detailTextView.text = data.explanation
                } else if let error = error {
                    self?.handleError(with: error)
                }
            }
        }
    }

    private func handleImageResponse() {
        viewModel?.imageHandler = { [weak self] (image, error) in
            DispatchQueue.main.async {
                if let image = image {
                    self?.apodImageView.image = image
                } else if let error = error {
                    self?.handleError(with: error)
                }
            }
        }
    }

    private func handleError(with error: ErrorType) {
        switch error {
        case .noNetwork:
            self.showAlert(with: "We are not connected to the internet, showing you the last image we have.")
        case .unknown(let reason):
            self.showAlert(with: reason)
        }
    }

    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Opps!!", message: message,
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Try Again",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.viewModel?.getAstronomyPictureOfTheDay()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

