//
//  AsyncRamen.swift
//
//
//  Created by Kevin Tan on 5/11/21.
//

import Foundation

// MARK: - DispatchQueue+async

extension DispatchQueue {
  func async<R>(execute: @escaping () async throws -> R) -> Task.Handle<R> {
    let handle = Task.runDetached(operation: execute)

    // Run the task
    _ = {
      async {
        handle.run() // deprecated method, for testing purposes only
      }
    }()

    return handle
  }

  @discardableResult
  func async<R>(
    in group: DispatchGroup,
    execute: @escaping () async throws -> R
  ) -> Task.Handle<R> {
    let handle = Task.runDetached(operation: execute)

    // Run the task
    group.enter()
    _ = {
      async {
        handle.run() // deprecated method, for testing purposes only
        group.leave()
      }
    }()

    return handle
  }
}

// MARK: - AsyncRamen

enum AsyncRamen {

  enum Chef {
    case sarah
    case kevin
  }

  // MARK: - Pork

  enum Pork {

    static func makePork() async -> String {
      // No requirements
      print("๐ Cooking pork (sorry Dylan) in rice cooker with char siu sauce, garlic, and green onion...")
      sleep(2)
      print("๐โ Pork is ready!\n")
      return "๐"
    }

  }

  // MARK: - Broth

  enum Broth {

    static func makeBroth() async -> String {
      // No requirements
      print("๐ต Boiling konbu, dried shiitake, and chicken bones...")
      sleep(2)
      print("๐ตโ Broth is finished!\n")
      return "๐ต"
    }

  }

  // MARK: - Noodles

  enum Noodles {

    enum CookingError: Error {
      case burntNoodles
    }

    private static func boilWater() async {
      // No requirements
      print("๐ง Boiling water...")
      sleep(2)
      print("๐งโ Water is boiled! How fun.\n")
    }

    static func makeNoodles(chef: Chef) async throws -> String {
      // Requirements:
      // - Boiled water

      await boilWater()

      print("๐ Boiling ramen noodles...")
      sleep(2)

      switch chef {
      case .sarah:
        print("๐โ Noodles ready ๐\n")
        return "๐"
      case .kevin:
        print("๐ฅ The noodles are BURNT!!!")
        throw CookingError.burntNoodles
      }
    }

  }

  // MARK: - Ajitama

  enum Ajitama {

    private static func makeCharSiuSauce() async {
      // No requirements
      print("โ๏ธ Making char siu sauce (soy sauce, mirin, and sugar)...")
      sleep(2)
      print("โ๏ธโ Sauce (crack) complete!\n")
    }

    private static func boilEggs() async {
      // No requirements
      print("๐ณ Boiling eggs...")
      sleep(2)
      print("๐ณโ Eggs are boiled!\n")
    }

    static func makeAjitama() async -> String {
      // Requirements:
      // - Char siu sauce
      // - Boiled eggs

      // Use a DispatchGroup to synchronize multiple asynchronous tasks
      let group = DispatchGroup()

      // Need to use a different queue or else we'll get deadlock
      let backgroundQueue = DispatchQueue.global(qos: .userInitiated)

      backgroundQueue.async(in: group) {
        await makeCharSiuSauce()
      }
      backgroundQueue.async(in: group) {
        await boilEggs()
      }
      group.wait()

      print("๐ฅ Soaking boiled eggs in sauce...")
      sleep(2)
      print("๐ฅโ Ajitama is ready!\n")
      return "๐ฅ"
    }

  }

  static func makeRamen(chef: Chef) async throws -> String {
    let pork = await Pork.makePork()
    let broth = await Broth.makeBroth()
    let noodles = await try Noodles.makeNoodles(chef: chef)
    let ajitama = await Ajitama.makeAjitama()

    print("๐ฒ Assembling ramen...")
    sleep(2)

    let components = [pork, broth, noodles, ajitama].joined()
    return "\(components) -> ๐ฒ Ramen is done!\n"
  }

}
