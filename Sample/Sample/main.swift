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
let jsonFileData = try Data(contentsOf: jsonFilePath! as URL)
let parsedJsonData = try JSONSerialization.jsonObject(with: jsonFileData as Data, options: []) as? NSArray

//result.txt file path
let resultFileName = "result.txt"
let resultFilePath = homeDirectoryPath.appendingPathComponent(resultFileName)
let filePathString = resultFilePath?.path

var avgDictionary = [String: Double]() //format - { <name1> : <average1> , <name2> : <average2> , ... }
var gradeDictionary = [String: String]()//format - { <name1> : <grade1> , <name2> : <grade2> , ... }
var totalAvg: Double = 0.0
var avgSum: Double = 0.0
let divisor: Double = pow(10, 2) //for round

//get the json data from dictioanry
for item in parsedJsonData! {
    
    var average: Double = 0.0
    var scoreSum: Double = 0
    
    
    var allDataDictionary = item as! Dictionary<String, Any> //format - { <name1>: <subject1 = score1, subject2 = score2 , ...>, <name2>: <subject1 = score1, subject2 = score2, ...>, ... }
    var score = allDataDictionary["grade"] as! Dictionary<String,Double> // format = { <subject1> : <score1>, <subject2> : <score2>, ... }
    var name:String = allDataDictionary["name"] as! String //format - { <name1>, <name2>, ... }
    
    //calculate the sum of score
    for scoreValue in score.values {
        scoreSum += scoreValue
    }
    
    //calculate average of score, update averageDictionary
    average =  scoreSum / Double(score.count)
    avgDictionary.updateValue(average, forKey: name) //format - { <name1> : <average1>, <name2> : <average2>, ...}
    avgSum += average
}

//calculate total average
totalAvg = avgSum /  Double((parsedJsonData?.count)!)

var roundedTotalAvg = round(totalAvg * divisor) / divisor // rounded the second decimal number
let buffer = "성적결과표\n\n전체 평균 : \(roundedTotalAvg)\n\n개인별 학점\n"
var contents:String = "" //contents of writing data

contents.append(buffer)

let gradeArray = ["A","B","C","D","F"]
var completionStudent = [String]()

//calculate grade
for (name, average) in avgDictionary {
    if ( average >= 90.0 && 100.0 > average){
        completionStudent.append(name)
        gradeDictionary.updateValue( gradeArray[0], forKey: name)
    } else if( average >= 80 && 90 > average){
        completionStudent.append(name)
        gradeDictionary.updateValue( gradeArray[1], forKey: name)
    } else if( average >= 70 && 80 > average){
        completionStudent.append(name)
        gradeDictionary.updateValue( gradeArray[2], forKey: name)
    } else if( average >= 60 && 70 > average){
        gradeDictionary.updateValue( gradeArray[3], forKey: name)
    } else {
        gradeDictionary.updateValue( gradeArray[4], forKey: name)
    }
}

//sort the name and grade
for (name,grade) in gradeDictionary.sorted(by: <) {
    contents.append("\(name)\t\t: \(grade)\n")
}

contents.append("\n수료생\n")

//sort the student
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

//write the contents to result.txt
do {
    try contents.write(toFile: filePathString!, atomically: false, encoding: String.Encoding.utf8)
   
}
catch let error as NSError {
    print("Error: \(error)")
}








