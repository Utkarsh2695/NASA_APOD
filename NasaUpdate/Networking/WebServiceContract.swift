//
//  WebServiceContract.swift
//  NasaUpdate
//
//  Created by Utkarsh Upadhyay (BLR GSS) on 11/04/21.
//

import Foundation

typealias CompletionHandler =  (Data?, ErrorType?) -> Void

protocol WebServiceContract {

    // To get the Astronomy Picture of the Day
    func getApod(with queryParam: [String: Any], _ completionHandler: @escaping CompletionHandler)

    // To download image with give URL
    func downloadImage(with URl: String, _ completionHandler: @escaping CompletionHandler)

}
