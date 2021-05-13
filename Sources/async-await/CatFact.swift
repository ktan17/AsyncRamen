//
//  CatFact.swift
//  
//
//  Created by Kevin Tan on 5/12/21.
//

import Foundation

private enum Constant {
  static let urlString = "https://catfact.ninja/fact"
  static let factKey = "fact"
}

enum CatFactError: Error {
  case badURL
  case serverError(underlyingError: Error)
  case badResponse
}

func fetchCatFact() async throws -> String {
  guard let url = URL(string: Constant.urlString) else {
    throw CatFactError.badURL
  }

  return await try withUnsafeThrowingContinuation { continuation in
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        continuation.resume(throwing: CatFactError.serverError(underlyingError: error))
      } else {
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
              let dict = json as? [String: Any],
              let fact = dict[Constant.factKey] as? String else {
          return continuation.resume(throwing: CatFactError.badResponse)
        }
        continuation.resume(returning: fact)
      }
    }
    .resume()
  }
}
