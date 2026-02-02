import Foundation

extension Set where Element: Equatable {
  mutating public func toggle(_ element: Element) {
    if contains(element) {
      remove(element)
    } else {
      insert(element)
    }
  }
}
