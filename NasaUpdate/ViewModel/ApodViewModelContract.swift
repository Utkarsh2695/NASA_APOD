//
//  ApodViewModelContract.swift
//  NasaUpdate
//
//  Created by Utkarsh Upadhyay (BLR GSS) on 10/04/21.
//

import Foundation
import UIKit

protocol ApodViewModelContract {

    var imageHandler: ((UIImage?, ErrorType?) -> Void)? {get set}

    var dataHandler: ((ApodModel?, ErrorType?) -> Void)? {get set}

    func getAstronomyPictureOfTheDay()
}
