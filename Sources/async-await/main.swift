import Foundation

//SyncRamen.makeRamen(chef: .kevin) { result in
//  switch result {
//  case .success(let ramen):
//    print(ramen)
//    exit(EXIT_SUCCESS)
//  case .failure(let error):
//    print("Failed to make ramen: \(error.localizedDescription)")
//    exit(EXIT_FAILURE)
//  }
//}
//
//let group = DispatchGroup()
//DispatchQueue.global().async(in: group) {
//  do {
//    let ramen = await try AsyncRamen.makeRamen(chef: .sarah)
//    print(ramen)
//    exit(EXIT_SUCCESS)
//  } catch {
//    print("Failed to make ramen: \(error.localizedDescription)")
//    exit(EXIT_FAILURE)
//  }
//
//}
//group.wait()

let catFactGroup = DispatchGroup()
DispatchQueue.global().async(in: catFactGroup) {
  do {
    let fact = await try fetchCatFact()
    print(fact)
    exit(EXIT_SUCCESS)
  } catch {
    print(error)
    exit(EXIT_FAILURE)
  }
}
catFactGroup.wait()

dispatchMain()
