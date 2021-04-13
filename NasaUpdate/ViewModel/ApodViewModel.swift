//
//  ApodViewModel.swift
//  NasaUpdate
//
//  Created by Utkarsh Upadhyay (BLR GSS) on 10/04/21.
//

import Foundation
import UIKit

class ApodViewModel: ApodViewModelContract {

    // MARK: - Properties
    let defaults = UserDefaults.standard

    private let webService: WebServiceContract
    private let dataPersistenceService: DataPersistenceServiceContract

    var imageHandler: ((UIImage?,  ErrorType?) -> Void)?
    var dataHandler: ((ApodModel?, ErrorType?) -> Void)?

    init() {
        self.webService = WebService()
        self.dataPersistenceService = DataPersistenceService()
    }

    // Method to fetch astronomy picture of the day

    func getAstronomyPictureOfTheDay() {
        // check for data persisted data to present and get it from cache.
        if let apod = dataPersistenceService.getStoredApodModel(),
           apod.date == self.getTodayDate() {
            self.dataHandler?(apod, nil)

            //check for image is present or not
            if let imageData = dataPersistenceService.getStoredImage() {
                self.imageHandler?(UIImage(data: imageData), nil)
            } else {
                self.downLoadImage(with: apod.url)
            }

        } else {
            let queryParam = [ApiKeys.apiKey.rawValue: GlobalConstants.NASA_API_KEY]
            webService.getApod(with: queryParam) { [weak self] (data, error) in
                guard let self = self else {
                    return
                }
                if let data = data {
                    self.handle(data)
                } else if let error = error {
                    self.dataHandler?(nil, error)
                }
            }
        }
    }

    private func handle(_ data: Data) {
        let apodModel = ApodModel(data: data)
        self.dataHandler?(apodModel, nil)

        //Save data to user defaults
        self.dataPersistenceService.store(apodModel)

        self.downLoadImage(with: apodModel?.url)
    }

    private func downLoadImage(with imageUrl: String?) {
        guard let imageUrl = imageUrl else {
            return
        }
        webService.downloadImage(with: imageUrl) { [weak self] (data, error) in
            guard let self = self else {
                return
            }
            if let data = data {
                self.imageHandler?(UIImage(data: data), nil)
                self.dataPersistenceService.storeImage(data: data)
            } else if let error = error {
                self.imageHandler?(nil, error)
            }
        }
    }

    // Function to get today's date according to UTC time zone
    private func getTodayDate() -> String {
        let date = Date()
        let formatter = DateFormatter()

        formatter.timeZone = TimeZone(abbreviation: "UTC")

        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

}

