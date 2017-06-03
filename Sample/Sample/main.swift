//
//  main.swift
//  Sample
//
//  Created by 박수현 on 2017. 5. 27..
//  Copyright © 2017년 clapwatermelon. All rights reserved.

import Foundation

//students.json file path, parsing
let jsonFileName = "students.json"
let homeDirectoryPath = NSURL(fileURLWithPath: NSHomeDirectory())
let jsonFilePath = homeDirectoryPath.appendingPathComponent(jsonFileName)
let data = try Data(contentsOf: jsonFilePath! as URL)
let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: []) as? NSArray
//result.txt file path
let resultFileName = "result.txt"
let resultFilePath = homeDirectoryPath.appendingPathComponent(resultFileName)
let filePathString = resultFilePath?.path

var avgDictionary = [String: Double]()
var scoreDictionary = [String: String]()
var totalAvg: Double = 0.0
var avgSum: Double = 0.0
let divisor: Double = pow(10, 2)

for item in parsedData! {
    
    var average: Double = 0.0
    var gradeSum: Double = 0
    var dataDictionary = item as! Dictionary<String, Any>
    var grade = dataDictionary["grade"] as! Dictionary<String,Double>
    var name:String = dataDictionary["name"] as! String
    
    for gradeValue in grade.values {
        gradeSum += gradeValue
    }
    
    average =  gradeSum / Double(grade.count)
    avgDictionary.updateValue(average, forKey: name)
    avgSum += average
}

totalAvg = avgSum /  Double((parsedData?.count)!)
totalAvg = round(totalAvg*100)/100

var roundedTotalAvg = ceil(totalAvg * divisor) / divisor
let buffer = "성적결과표\n\n전체 평균 : \(roundedTotalAvg)\n\n개인별 학점\n"
var contents:String = ""

contents.append(buffer)

let scoreArray = ["A","B","C","D","F"]
var completionStudent = [String]()

for (key, value) in avgDictionary {
    if ( value >= 90.0 && 100.0 > value){
        completionStudent.append(key)
        scoreDictionary.updateValue( scoreArray[0], forKey: key)
    } else if( value >= 80 && 90 > value){
        completionStudent.append(key)
        scoreDictionary.updateValue( scoreArray[1], forKey: key)
    } else if( value >= 70 && 80 > value){
        completionStudent.append(key)
        scoreDictionary.updateValue( scoreArray[2], forKey: key)
    } else if( value >= 60 && 70 > value){
        scoreDictionary.updateValue( scoreArray[3], forKey: key)
    } else {
        scoreDictionary.updateValue( scoreArray[4], forKey: key)
    }
}

for (key,value) in scoreDictionary.sorted(by: <) {
    contents.append("\(key)\t\t: \(value)\n")
}
contents.append("\n수료생\n")

for sortedStudent in completionStudent.sorted(){
    completionStudent.append(sortedStudent)
    completionStudent.remove(at: 0)
}

var studentCount: Int = 0
for student in completionStudent {
    studentCount += 1
    if ( studentCount == completionStudent.count){
        contents.append("\(student)")
    } else {
        contents.append("\(student), ")
    }
}

do {
    try contents.write(toFile: filePathString!, atomically: false, encoding: String.Encoding.utf8)
   
}
catch let error as NSError {
    print("Error: \(error)")
}








