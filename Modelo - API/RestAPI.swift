//
//  RestAPI.swift
//  TesteExtensions
//
//  Created by humberto Lima on 27/06/20.
//  Copyright © 2020 humberto Lima. All rights reserved.
//

import Foundation

struct modelExemplo: Codable {
    var id: Int?
}

class Api: NSObject {

    // url do servidor com os Endpoints
    let servidor = "URL SERVIDOR "
    
    func requestBase(dataEnviar: Data?, urlEnviar: String, headerEnviar:[String: String], tipoEnvio: String, onSuccess:@escaping(Bool, Data?) -> Void) {
        let urlTemp = urlEnviar.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        var request = URLRequest(url: URL(string: "\(servidor)\(urlTemp)")!)
        request.httpMethod = tipoEnvio
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        if dataEnviar != nil { request.httpBody = dataEnviar }
        if headerEnviar != ["":""] { request.allHTTPHeaderFields = headerEnviar }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) {jsonRet,response,error in
            DispatchQueue.main.async {
                let httpResponse = response as? HTTPURLResponse
                if (httpResponse?.statusCode ?? 0) >= 200 && (httpResponse?.statusCode ?? 0) <= 299 {
                    onSuccess(true, jsonRet)
                }else if (httpResponse?.statusCode ?? 0) >= 400 && (httpResponse?.statusCode ?? 0) <= 499 {
                    if  httpResponse?.statusCode == 400 {
                        print("Bad Request --- \(httpResponse?.statusCode ?? 0)")
                    }else if  httpResponse?.statusCode == 401 {
                        print("Unauthorized --- \(httpResponse?.statusCode ?? 0)")
                    }else if  httpResponse?.statusCode == 403 {
                        print("Forbidden --- \(httpResponse?.statusCode ?? 0)")
                    }else if  httpResponse?.statusCode == 404 {
                        print("Not Found --- \(httpResponse?.statusCode ?? 0)")
                    }else{
                        print("Erro --- \(httpResponse?.statusCode ?? 0)")
                    }
                    onSuccess(false, Data())
                }else if httpResponse?.statusCode == 500 {
                    print("Internal Server Error --- \(httpResponse?.statusCode ?? 0)")
                    onSuccess(false, Data())
                }else{
                    print(httpResponse?.statusCode ?? 0)
                    onSuccess(false, Data())
                }
            }
        }
        dataTask.resume()
    }
    
    func modeloPostSemDados(onSuccess:@escaping(Bool, String) -> Void) {
        self.requestBase(dataEnviar: nil, urlEnviar: "EndPoint", headerEnviar: ["":""], tipoEnvio: "POST") { (ret, dataRet) in
            if ret {
                onSuccess(true, "")
            }else{
                onSuccess(false, "Erro 1.1 \n Ocorreu um erro ao se conectar com o servidor, verifique sua conexão com a internet e tente novamente.")
            }
        }
    }
    
    func modeloPostSemDados(modelEnviar: modelExemplo, onSuccess:@escaping(Bool, String) -> Void) {
        let encoder = JSONEncoder()
        let jsonEnviar = try! encoder.encode(modelEnviar)
        self.requestBase(dataEnviar: jsonEnviar, urlEnviar: "endPoint", headerEnviar: ["":""], tipoEnvio: "POST") { (ret, dataRet) in
            if ret {
                if let temp = try? JSONDecoder().decode(modelExemplo.self, from: dataRet!) {
                    print(temp)
                    onSuccess(true, "")
                }else{
                    onSuccess(false, "Erro 2.1 \n Ocorreu um erro ao se conectar com o servidor, verifique sua conexão com a internet e tente novamente.")
                }
            }else{
                onSuccess(false, "Erro 2.2 \n Ocorreu um erro ao se conectar com o servidor, verifique sua conexão com a internet e tente novamente.")
            }
        }
    }
    
    func modeloGet(modelEnviar: modelExemplo, onSuccess:@escaping(Bool, String) -> Void) {
        self.requestBase(dataEnviar: nil, urlEnviar: "endPoint", headerEnviar: ["":""], tipoEnvio: "GET") { (ret, dataRet) in
            if ret {
                if let temp = try? JSONDecoder().decode(modelExemplo.self, from: dataRet!) {
                    print(temp)
                    onSuccess(true, "")
                }else{
                    onSuccess(false, "Erro 3.1 \n Ocorreu um erro ao se conectar com o servidor, verifique sua conexão com a internet e tente novamente.")
                }
            }else{
                onSuccess(false, "Erro 3.2 \n Ocorreu um erro ao se conectar com o servidor, verifique sua conexão com a internet e tente novamente.")
            }
        }
    }
}
