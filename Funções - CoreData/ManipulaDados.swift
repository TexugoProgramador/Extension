//
//  ManipulaDados.swift
//  TesteExtensions
//
//  Created by humberto Lima on 27/06/20.
//  Copyright © 2020 humberto Lima. All rights reserved.
//

import UIKit
import CoreData

struct modelTempSalvar: Codable {
    var id: Int?
    var nome: String?
}

class ManipulaDados {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func salvaDados(modelSalvar:modelTempSalvar, nomeEntity: String){
        if nomeEntity != "" {
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: nomeEntity, in: managedContext)!
            let modelInserir = NSManagedObject(entity: entity,  insertInto: managedContext)
            
            modelInserir.setValue((modelSalvar.id ?? 0), forKey: "id")
            modelInserir.setValue((modelSalvar.nome ?? ""), forKey: "name"
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Não foi possível salvar erro. \(error), \(error.userInfo)")
            }
        }else{
            return
        }
    }
    
    func limpaEntities(entity:String) {
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try managedContext.execute(request)
        } catch {
            return
        }
    }
}
