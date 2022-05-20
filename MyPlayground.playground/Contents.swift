import UIKit

var greeting = "Hello, playground"
let today = Date()
let dueDate = Calendar.current.date(byAdding: .day, value: 1, to: today)!

let result = Calendar.current.compare(dueDate, to: today, toGranularity: .hour)

print(result == .orderedDescending)

