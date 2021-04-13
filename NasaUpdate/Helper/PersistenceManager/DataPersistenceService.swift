//
//  DataPersistenceService.swift
//  NasaUpdate
//
//  Created by Utkarsh Upadhyay (BLR GSS) on 12/04/21.
//

import Foundation

enum UserDefaultKey: String {
    case apodInfoObjc23
    case apod23
}

class DataPersistenceService: DataPersistenceServiceContract {

    let defaults = UserDefaults.standard

    func store(_ data: ApodModel?) {
        guard let data = data else {
            return
        }
        
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            defaults.setValue(encodedData, forKey: UserDefaultKey.apodInfoObjc23.rawValue)
        } catch {
            print("Not able to encode due to \(error.localizedDescription)")
        }
    }


    func getStoredApodModel() -> ApodModel? {
        var apod: ApodModel?
        guard  let storedApod = defaults.object(forKey: UserDefaultKey.apodInfoObjc23.rawValue) as? Data else {
            return apod
        }

        let decoder = JSONDecoder()
        do {
            let apodData = try decoder.decode(ApodModel.self, from: storedApod)
            apod = apodData
        } catch {
            print("Not able to decode due to \(error.localizedDescription)")
        }
        return apod
    }

    func storeImage(data: Data) {
        defaults.setValue(data, forKey: UserDefaultKey.apod23.rawValue)
    }

    func getStoredImage() -> Data? {
        return defaults.object(forKey: UserDefaultKey.apod23.rawValue) as? Data
    }
}
