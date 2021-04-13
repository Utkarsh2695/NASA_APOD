//
//  DataPersistenceServiceContract.swift
//  NasaUpdate
//
//  Created by Utkarsh Upadhyay (BLR GSS) on 12/04/21.
//

import Foundation

protocol DataPersistenceServiceContract {

    //To store the featched data into user defaults
    func store(_ data: ApodModel?)

    //To get the stored apod info in  user defaults
    func getStoredApodModel() -> ApodModel?

    //To store the dowloaded image
    func storeImage(data: Data)

    // To get the stoted image
    func getStoredImage() -> Data?
}
