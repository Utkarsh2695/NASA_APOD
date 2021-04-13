//
//  ApodModel.swift
//  NasaUpdate
//
//  Created by Utkarsh Upadhyay (BLR GSS) on 10/04/21.
//

import Foundation

struct ApodModel: Codable {

    var title: String?
    var explanation: String?
    var date: String?
    var url: String?

    // Decoding the data and initializing ApodModel
    init?(data: Data?) {
        guard let data = data else {
            return
        }
        do {
            let apodInfo = try JSONDecoder().decode(ApodModel.self, from: data)
            self.title = apodInfo.title
            self.explanation = apodInfo.explanation
            self.date = apodInfo.date
            self.url = apodInfo.url
        } catch {
            print("Not able to to decode due to \(error.localizedDescription)")
        }
    }

    enum Codingkeys: String, CodingKey {
        case title
        case explanation
        case date
        case url
    }
}
