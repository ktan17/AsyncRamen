//
//  SyncRamen.swift
//  
//
//  Created by Kevin Tan on 5/11/21.
//

import Foundation

enum SyncRamen {

  enum Chef {
    case sarah
    case kevin
  }

  // MARK: - Pork

  enum Pork {

    static func makePork(completion: @escaping (String) -> Void) {
      // No requirements
      print("๐ Cooking pork (sorry Dylan) in rice cooker with char siu sauce, garlic, and green onion...")
      sleep(2)
      print("๐โ Pork is ready!\n")
      completion("๐")
    }

  }

  // MARK: - Broth

  enum Broth {

    static func makeBroth(completion: @escaping (String) -> Void) {
      // No requirements
      print("๐ต Boiling konbu, dried shiitake, and chicken bones...")
      sleep(2)
      print("๐ตโ Broth is finished!\n")
      completion("๐ต")
    }

  }

  // MARK: - Noodles

  enum Noodles {

    enum CookingError: Error {
      case burntNoodles
    }

    private static func boilWater(completion: @escaping () -> Void) {
      // No requirements
      print("๐ง Boiling water...")
      sleep(2)
      print("๐งโ Water is boiled! How fun.\n")
      completion()
    }

    static func makeNoodles(
      chef: Chef,
      completion: @escaping (() throws -> String) -> Void
    ) {
      // Requirements:
      // - Boiled water

      boilWater {
        print("๐ Boiling ramen noods...")
        sleep(2)

        switch chef {
        case .sarah:
          print("๐โ Noodles ready ๐\n")
          completion({ return "๐" })
        case .kevin:
          print("๐ฅ The noodles are BURNT!!!")
          completion({ throw CookingError.burntNoodles })
        }
      }
    }

  }

  // MARK: - Ajitama

  enum Ajitama {

    private static func makeCharSiuSauce(completion: @escaping () -> Void) {
      // No requirements
      print("โ๏ธ Making char siu sauce (soy sauce, mirin, and sugar)...")
      sleep(2)
      print("โ๏ธโ Sauce (crack) complete!\n")
      completion()
    }

    private static func boilEggs(completion: @escaping () -> Void) {
      // No requirements
      print("๐ณ Boiling eggs...")
      sleep(2)
      print("๐ณโ Eggs are boiled!\n")
      completion()
    }

    static func makeAjitama(completion: @escaping (String) -> Void) {
      // Requirements:
      // - Char siu sauce
      // - Boiled eggs

      // Use a DispatchGroup to synchronize multiple asynchronous tasks
      let group = DispatchGroup()

      // Need to use a different queue or else we'll get deadlock
      let backgroundQueue = DispatchQueue.global(qos: .userInitiated)

      group.enter()
      backgroundQueue.async(group: group) {
        makeCharSiuSauce(completion: group.leave)
      }

      group.enter()
      backgroundQueue.async(group: group) {
        boilEggs(completion: group.leave)
      }

      group.notify(queue: .main) {
        print("๐ฅ Soaking boiled eggs in sauce...")
        sleep(2)
        print("๐ฅโ Ajitama is ready!\n")
        completion("๐ฅ")
      }
    }

  }

  // MARK: - Ramen factory

  static func makeRamen(
    chef: Chef,
    completion: @escaping (Result<String, Error>) -> Void
  ) {
    Pork.makePork { pork in
      Broth.makeBroth { broth in
        Noodles.makeNoodles(chef: chef) { inner in
          let noodles: String
          do {
            noodles = try inner()
            Ajitama.makeAjitama { ajitama in
              print("๐ฒ Assembling ramen...")
              sleep(2)

              let components = [pork, broth, noodles, ajitama].joined()
              completion(.success("\(components) -> ๐ฒ Ramen is done!\n"))
            }
          } catch {
            completion(.failure(error))
          }
        }
      }
    }
  }

}
