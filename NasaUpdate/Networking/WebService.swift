//
//  WebService.swift
//  NasaUpdate
//
//  Created by Utkarsh Upadhyay (BLR GSS) on 11/04/21.
//

import Foundation

class WebService: WebServiceContract {

    private let baseURL = "https://api.nasa.gov/"
    private let router = "planetary/apod"

    private let internetConnectivity: MonitorInternetConnectivity

    init() {
        self.internetConnectivity = MonitorInternetConnectivity()
    }

    func getApod(with queryParam: [String: Any], _ completionHandler: @escaping CompletionHandler) {
        if internetConnectivity.isConnected() {
            let completeURLString = baseURL + router
            process(urlString: completeURLString, with: queryParam, completionHandler)
        } else {
            completionHandler(nil, ErrorType.noNetwork)
        }
    }


    func downloadImage(with url: String, _ completionHandler: @escaping CompletionHandler) {
        if internetConnectivity.isConnected() {
            process(urlString: url, completionHandler)
        } else {
            completionHandler(nil, ErrorType.noNetwork)
        }
    }


    private func process(urlString: String, for method: String = "GET",
                         with queryParam: [String: Any]? = nil,
                         _ completionHandler: @escaping CompletionHandler) {
        guard let url = getURL(with: urlString, with: queryParam) else {
            return
        }

        // Make request
        var request = URLRequest(url: url)
        request.httpMethod = method

        // Instantiate session
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                completionHandler(data, nil)
            } else if let error = error {
                completionHandler(nil , ErrorType.unknown(reason: error.localizedDescription))
            }
        }
        task.resume()
    }

    //To add any query param to url if exist
    private func getURL(with urlSting: String, with params: [String: Any]?) -> URL? {
        var queryItems: [URLQueryItem]?
        if let params = params {
            queryItems = params.map { URLQueryItem(name: "\($0)", value: "\($1)") }
        }

        guard var urlComp = URLComponents(string: urlSting) else {
            return nil
        }

        urlComp.queryItems = queryItems
        return urlComp.url
    }
}
