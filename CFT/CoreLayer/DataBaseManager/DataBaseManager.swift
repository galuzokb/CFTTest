//
//  DataBaseManager.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/21/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import Foundation
import CoreData

class DataBaseManager: DataBaseManagerType {
    
    public static let shared = DataBaseManager()
    
    // MARK: - NSPersistenContainer for iOS 10 and newer
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CFTModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard error == nil else {
                fatalError("Unresolved error while loading persistent store")
            }
        })
        return container
    }()
    
    // MARK: - Shit for old iOS
    
    lazy var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle(for: DataBaseManager.self).url(forResource: "CFTModle", withExtension: "momd") else {
            //            fatalError("Failed to get model url.")
            return nil
        }
        
        guard let mod = NSManagedObjectModel(contentsOf: modelURL) else {
            //            fatalError("Failed to create managed object model")
            return nil
        }
        
        return mod
    }()
    
    lazy var persistenStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let mom = managedObjectModel else { return nil }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        let url = applicationDocumentDirectory.appendingPathComponent("CFTModle.xcdatamodeld")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            return nil
        }
        
        return coordinator
    }()
    
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        guard let coordinator = persistenStoreCoordinator else {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    init() {
        print("data base manager init")
    }
    
    func save(_ images: [CFTImage]) throws {
        do {
            if #available(iOS 10.0, *) {
                try saveNew(images)
            } else {
                try saveOld(images)
            }
            print("images has been saved to db")
        } catch {
            throw BDError(message: "Failed to save images.")
        }
    }
    
    func save(_ image: CFTImage) throws {
        do {
            if #available(iOS 10.0, *) {
                try saveNew([image])
            } else {
                try saveOld([image])
            }
            print("image has been saved to db")
        } catch {
            throw BDError(message: "Failed to save image.")
        }
    }
    
    func fetchAll() throws -> [CFTImage]? {
        do {
            var fetched: [CFTImage]?
            if #available(iOS 10.0, *) {
                fetched = try fetchNew()
                
            } else {
                fetched = try fetchOld()
            }
            print("fetched all images form db")
            return fetched
        } catch {
            throw BDError(message: "Failed to fetch cached images.")
        }
    }
    
    func deleteAll() throws {
        do {
            if #available(iOS 10.0, *) {
                try deleteNew()
            } else {
                try deleteOld()
            }
        } catch {
            throw BDError(message: "Failed to delete cached images.")
        }
    }
    
    func delete(_ image: CFTImage) throws {
        do {
            let predicate = NSPredicate(format: "id == %@", image.id)
            if #available(iOS 10.0, *) {
                try deleteNew(withPredicate: predicate)
            } else {
                try deleteOld(withPredicate: predicate)
            }
        } catch {
            throw BDError(message: "Failed to delete :\(image)")
        }
    }
    
    // MARK: - Private Methods
    
    @available(iOS 10.0, *)
    private func saveNew(_ images: [CFTImage]) throws {
        images.forEach { persistentContainer.viewContext.insert(CFTStoredImage($0, withContext: persistentContainer.viewContext)) }
        try persistentContainer.viewContext.save()
    }
    
    @available(iOS 10.0, *)
    private func fetchNew() throws -> [CFTImage]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CFTStoredImage")
        let fetched = try persistentContainer.viewContext.fetch(fetchRequest)
        
        guard fetched.count > 0 else { return nil }
        
        return fetched
            .compactMap { $0 as? CFTStoredImage }
            .map { CFTImage($0) }
            .sorted { $0.modificationDate > $1.modificationDate }
    }
    
    @available(iOS 10.0, *)
    private func deleteNew(withPredicate predicate: NSPredicate? = nil) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CFTStoredImage")
        fetchRequest.predicate = predicate
        try persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest))
        try persistentContainer.viewContext.save()
    }
    
    // MARK: - Fall back to older iOS versions
    
    private func saveOld(_ images: [CFTImage]) throws {
        guard
            let context = managedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "CFTStoredImage", in: context)
        else {
            return
        }
        images.forEach { context.insert(CFTStoredImage($0, withContext: context, entity: entity)) }
        try context.save()
    }
    
    private func fetchOld() throws -> [CFTImage]? {
        guard let managedObjectContext = managedObjectContext else {
            return nil
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CFTStoredImage")
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "CFTStoredImage", in: managedObjectContext)
        let fetched = try managedObjectContext.fetch(fetchRequest)
        return fetched
            .compactMap { $0 as? CFTStoredImage }
            .map { CFTImage($0) }
            .sorted { $0.modificationDate > $1.modificationDate }
    }
    
    private func deleteOld(withPredicate predicate: NSPredicate? = nil) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CFTStoredImage")
        fetchRequest.predicate = predicate
        try managedObjectContext?.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest))
        try managedObjectContext?.save()
    }
}
