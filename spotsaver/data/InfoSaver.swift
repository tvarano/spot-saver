//
//  InfoSaver.swift
//  spotsaver
//
//  Created by Thomas Varano on 11/23/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation

struct keys {
    static let longitude = "long"
    static let latitude = "lat"
}

class InfoSaver {
    
    /** DEPRECATED
     */
    static func isEmpty() -> Bool {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Pin.ArchiveURL.path) == nil
//        return UserDefaults.standard.dictionaryRepresentation().isEmpty
    }
    
    /**
     DEPRECATED
    */
    static func save(place: Pin) {
        let isSaved = NSKeyedArchiver.archiveRootObject(place, toFile: Pin.ArchiveURL.path)
        if !isSaved {
            print("Failed to save items...")
        }
    }
    
    /** DEPRECATED
     */
    static func getLocation() -> Pin? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Pin.ArchiveURL.path) as? Pin
    }

    
    static func getPins() -> PinManager? {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: PinManager.self, requiringSecureCoding: true)

            return try NSKeyedUnarchiver.unarchivedObject(ofClass: PinManager.self, from: data)
        } catch {
            print("unable to read data")
            return nil
        }
    }
    
    static func writePins() {
        let randomFilename = UUID().uuidString
        let fullPath = getDocumentsDirectory().appendingPathComponent(randomFilename)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: PinManager.self, requiringSecureCoding: true)
            try data.write(to: fullPath)
        } catch {
            print("Couldn't write file")
        }
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
