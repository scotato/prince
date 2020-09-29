//
//  Octoprint.swift
//  https://docs.octoprint.org/en/master/api/datamodel.html
//  Shared
//
//  Created by Scott Dodge on 9/26/20.
//

import Foundation

struct PrintFile: Codable {
    let name: String?
    let display: String?
    let path: String?
    let type: String?
    let typePath: String?
}


struct PrintJob: Codable {
    enum CodingKeys: String, CodingKey {
        case file, estimatedPrintTime, lastPrintTime, filament
        case filamentLength = "filament.length"
        case filamentVolume = "filament.volume"
    }
    
    let file: PrintFile?
    let estimatedPrintTime: Int?
    let lastPrintTime: Int?
    let filament: String?
    let filamentLength: Int?
    let filamentVolume: Float?
}

struct PrintProgress: Codable {
    enum TimeLeftOrigin: String, Codable {
        case linear, analysis, estimate, average
        case mixedAnalysis = "mixed-analysis"
        case mixedAverage = "mixed-average"
    }
    
    let completion: Float?
    let filepos: Int?
    let printTime: Int?
    let printTimeLeft: Int?
    let printTimeLeftOrigin: TimeLeftOrigin?
}

struct Job: Codable {
    enum JobState: String, Codable {
        case operational = "Operational"
        case printing = "Printing"
        case pausing = "Pausing"
        case paused = "Paused"
        case cancelling = "Cancelling"
        case error = "Error"
        case offline = "Offline"
    }
    
    let job: PrintJob?
    let progress: PrintProgress?
    let state: JobState?
}

var JobRequest: URLRequest {
    let OCTOPRINT_KEY = ""
    let OCTOPRINT_HOST = ""
    let url = URL(string: "\(OCTOPRINT_HOST)/api/job")!
    var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(OCTOPRINT_KEY, forHTTPHeaderField: "X-Api-Key")
    
    return urlRequest
}

func parseJobJSON(data: Data) -> Job? {
    
    var returnValue: Job?
    do {
        returnValue = try JSONDecoder().decode(Job.self, from: data)
    } catch {
        print("Error took place\(error.localizedDescription).")
    }
    
    return returnValue
}
