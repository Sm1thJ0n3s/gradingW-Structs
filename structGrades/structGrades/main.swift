//
//  main.swift
//  structGrades
//
//  Created by StudentAM on 2/8/24.
//

import Foundation
import CSV

struct StudentInfo {
    var name: String
    var grades: [String]
    var finalGrade: Double
}

var students: [StudentInfo] = []

do{
    let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv")
    let csv = try CSVReader(stream: stream!)
   
    while let row = csv.next(){
        manageData(row: row)
    }
    print(students)
    print("Hello Professor Gomez")
    printTeacherInputs()
}
catch{
    print("! There was a change to the grades or an error in your file !")
    print("We'll shut down this program for a brief moment. Please try again or check upon the file you want to view if it has changed or corrupted.")
}


func manageData(row: [String]){
    var name: String = ""
    var tempArray: [String] = []
    for i in row.indices {
        if i == 0 {
            name = row[i]
        } else {
            tempArray.append(row[i])
        }
    }
    let finalGrade = calcFinalGrades(grades: tempArray)
    let studentInfo: StudentInfo = StudentInfo(name: name, grades: tempArray, finalGrade: finalGrade)
    students.append(studentInfo)
}
func calcFinalGrades (grades: [String]) -> Double {
    var sum: Double = 0.0
    for grade in grades {
        sum += Double(grade)!
    }
    return sum / 10
}

var assignIndex: Int = 0
var studentChecked: Bool = false

// Prints the options the teacher would want to do to check on the students.
func printTeacherInputs () {
    var userChoice: String = "0"
    // While loop will stop the program when the teacher chooses the exit the program.
    while userChoice != "6" {
        print("What would you like to do?")
        print("")
        print("1) Display grades") // Gives option to see grades of a student or all sutdents AND to see a grade or all grades.
        print("2) Find grade average") // Finds the grade average of the class of a selected assignment.
        print("3) Print lowest grade") // Prints the 5 lowest final grades.
        print("4) Print highest grade") // Prints the 5 highest final grades.
        print("5) Grade Range") // Displays the grades of each student that fits within the range.
        print("6) Quit") // Exit the program.
        print("")
        
        if let userInput = readLine() {
            teacherInputHandler(option: userInput)
            userChoice = userInput

        }
    }
}
// Handles with the inputs that the teacher gives to the program.
func teacherInputHandler(option: String) {
    if option == "Display" || option == "display" || option == "1" {
        display(student: "None", assignment: "None")
    } else if option == "Grade average" || option == "2" {
        gradeAverage(student: "None", assignment: "None")
    } else if option == "Lowest" || option == "Lowest grade" || option == "Grades to worry" || option == "3" {
        lowestFinalGrades()
    } else if option == "Highest" || option == "Highest grade" || option == "Least to worry" || option == "4" {
        highestFinalGrades()
    } else if option == "Grade range" || option == "Range" || option == "5" {
        gradeRange(minimum: "None", maximum: "None")
    } else if option == "Quit" || option == "quit" || option == "Leave" || option == "leave" || option == "Stop app" || option == "stop app" || option == "6" {
        quitProgram()
    } else {
        var responseToInvalid: Int = 0
        responseToInvalid = Int.random(in: 1...5)
        if responseToInvalid == 1 {
            print("Please input a valid option professor.")
        } else if responseToInvalid == 2 {
            print("The option you entered is not allowed.")
        } else if responseToInvalid == 3 {
            print("Please check your spelling before entering.")
        } else if responseToInvalid == 4 {
            print("Come on, you're a professor. Please type like one of the options.")
        } else if responseToInvalid == 5 {
            print("Read the options you are allowed to enter, please professor.")
        }
    }
}
// Displays student grades that is in the teacher's class.
func display (student: String, assignment: String) {
    if student == "None" {
        print("Which student would you like to view?")
        print("")
        
        if let userInput = readLine() {
            studentChecked = checkStudentName(studentName: userInput)
            display(student: userInput, assignment: "None")
        }
    } else if assignment == "None"{
        if studentChecked == true {
            print("Which assignment would you like to see?")
            print("")
            
            if let userInput = readLine() {
                display(student: student, assignment: userInput)
            }
        } else {
            print("ERROR: Student's name wasn't found. Please enter the name of the student from your class.")
            print("")
            display(student: "None", assignment: "None")
        }
    } else if assignment != "None" {
        if student == "All" || student == "all" {
            if assignment == "All" || assignment == "all" {
                displayAllStudentsAssignments()
            } else if Int(assignment) != nil {
                displayAllStudentsAssignment(wantedAssignment: Int(assignment)!)
            } else {
                print("You did not enter an assignment or all the assignments. Please try again")
                display(student: student, assignment: "None")
            }
        } else {
            if assignment == "All" || assignment == "all" {
                for displayInfo in students {
                    if displayInfo.name.lowercased() == student.lowercased() {
                        print("Here are \(student)'s grades:")
                        print(displayInfo.grades)
                    }
                }
            } else if Int(assignment) != nil {
                for displayInfo in students {
                    if displayInfo.name.lowercased() == student.lowercased() {
                        print("Here is \(student)'s grade on assignment #\(assignment): \(displayInfo.grades[(assignment as NSString).integerValue - 1])")
                    }
                }
            } else {
                print("You did not enter an assignment or all the assignments. Please try again")
                display(student: student, assignment: "None")
            }
        }
    }
    studentChecked = false
}
// Created to check a student's name. If they find it, it'll send back the student's name as it is accepted.
// This function is most definite for multiple functions (display and average functions).
// Made for Struct assignment exclusive.
func checkStudentName (studentName: String) -> Bool {
    for student in students {
        print(student.name.lowercased())
        if student.name.lowercased() == studentName.lowercased() {
                return true
        } else if (studentName == "All" || studentName == "all") {
            return true
        }
    }
    return false
}
// A branching part of display function. This displays all the students' grades without an average.
func displayAllStudentsAssignments () {
    var gradeIndex: Int = 0
    for student in students {
        print("")
        print(student.name + " ", terminator: "")
        for grade in students {
            if gradeIndex < grade.grades.count {
                print("\(grade.grades[gradeIndex]).0, ", terminator: "")
                gradeIndex += 1
            }
        }
        gradeIndex = 0
    }
    print("")
}
// Another branching part of display. This displays the grades of each student of a specific assignment.
func displayAllStudentsAssignment (wantedAssignment: Int) {
    assignIndex = wantedAssignment - 1
    var assignmentGrades: [Int] = []
    for grade in students {
        assignmentGrades.append(Int(grade.grades[assignIndex])!)
    }
    print("Assignment #\(wantedAssignment)'s class grades: \(assignmentGrades)")
}

// Displays the average of either grades of the assignment or grades of the entire class (final grades, then class grade average)
func gradeAverage (student: String, assignment: String) {
    if student == "None" {
        print("Enter a student's name below:")
        
        if let userInput = readLine() {
            // Now checks if the student's name (what the teacher inputs) is in the the files
            studentChecked = checkStudentName(studentName: userInput)
            gradeAverage(student: userInput, assignment: "None")
        }
    } else if assignment == "None" {
        if studentChecked == true {
            print("Please enter a number greater than zero to view to average grade of assignments")
            print("")
            if let userInput = readLine() {
                gradeAverage(student: student, assignment: userInput)
            }
        } else {
            print("ERROR: Student's name wasn't found. Please enter the name of the student from your class.")
            print("")
            gradeAverage(student: "None", assignment: "None")
        }
    } else if assignment != "None" {
        // If statements are similar to display function.
        if student == "All" || student == "all" {
            if assignment == "All" || assignment == "all" {
                displayAllFinalGrades()
                classAverage()
            } else if Int(assignment) != nil {
                avgClassAssignmentGrade(assignment: Int(assignment)!)
            } else {
                print("ERROR: The assignment you were asking for was not indentified. Please enter a number to view an assignment")
                gradeAverage(student: student, assignment: "None")
            }
        } else {
            if assignment == "All" || assignment == "all" {
                for studentName in students {
                    if studentName.name.lowercased() == student.lowercased() {
                        print("Here is \(studentName.name)'s final grade: \(studentName.finalGrade)")
                    }
                }
            } else if Int(assignment) != nil {
                for studentName in students {
                    if studentName.name.lowercased() == student.lowercased() {
                        print("Although available to do this similarly in the display grades function, here is \(studentName.name)'s grade:")
                        print("Requested grade view: \(studentName.grades[assignIndex])")
                    }
                }
            } else {
                print("ERROR: The assignment you were asking for was not indentified. Please enter a number to view an assignment")
                gradeAverage(student: student, assignment: "None")
            }
        }
    }
    studentChecked = false
}
// The class average branch of gradeAverage. Activates when all of the students' final grades are wanted to be display.
func classAverage () {
    var sum: Double = 0.0
    for grade in students {
        sum += grade.finalGrade
    }
    let classAvg = sum / Double(students.count)
    print("This is the class average final grades: \(String(format:"%.1f", classAvg))")
}
// Displays the final grades of all students. That's what it actually does.
// Another branching part to gradeAverage, comes before the classAverage due to the teacher wanting the entire grades of students which will round it all up to final grades.
func displayAllFinalGrades () {
    for student in students {
        print("\(student.name)'s final grades: \(student.finalGrade)")
    }
}
// Another branching part of gradeAverage. This takes the assignment grades of each student and averages it out.
func avgClassAssignmentGrade (assignment: Int) {
    assignIndex = assignment - 1
    var sum: Int = 0
    for grade in students {
        sum += Int(grade.grades[assignIndex])!
    }
    let assignmentAvg: Double = Double(sum) / Double(students.count)
    print("This is the class average of assignment #\(assignment): \(String(format:"%.1f", assignmentAvg))")
}
// Displays the 5 lowest final grades in the whole class
func lowestFinalGrades () {
    var lowestFinalGrade: Double = 100
    var lowestGradeName: String = ""
    
    var secondLowest: Double = 100
    var secondLowestName: String = ""
    
    var thirdLowest: Double = 100
    var thirdLowestName: String = ""
    
    var fourthLowest: Double = 100
    var fourthLowestName: String = ""
    
    var fifthLowest: Double = 100
    var fifthLowestName: String = ""
    
    for finalGrade in students {
        if Double(finalGrade.finalGrade) < fifthLowest {
            if Double(finalGrade.finalGrade) < fourthLowest {
                if Double(finalGrade.finalGrade) < thirdLowest {
                    if Double(finalGrade.finalGrade) < secondLowest {
                        if Double(finalGrade.finalGrade) < lowestFinalGrade {
                            fifthLowest = fourthLowest
                            fifthLowestName = fourthLowestName
                            
                            fourthLowest = thirdLowest
                            fourthLowestName = thirdLowestName
                            
                            thirdLowest = secondLowest
                            thirdLowestName = secondLowestName
                            
                            secondLowest = lowestFinalGrade
                            secondLowestName = lowestGradeName
                            
                            lowestFinalGrade = Double(finalGrade.finalGrade)
                            lowestGradeName = finalGrade.name
                        } else {
                            fifthLowest = fourthLowest
                            fifthLowestName = fourthLowestName
                            
                            fourthLowest = thirdLowest
                            fourthLowestName = thirdLowestName
                            
                            thirdLowest = secondLowest
                            thirdLowestName = secondLowestName
                            
                            secondLowest = Double(finalGrade.finalGrade)
                            secondLowestName = finalGrade.name
                        }
                    } else {
                        fifthLowest = fourthLowest
                        fifthLowestName = fourthLowestName
                        
                        fourthLowest = thirdLowest
                        fourthLowestName = thirdLowestName
                        
                        thirdLowest = Double(finalGrade.finalGrade)
                        thirdLowestName = finalGrade.name
                    }
                } else {
                    
                    fifthLowest = fourthLowest
                    fifthLowestName = fourthLowestName
                    
                    fourthLowest = Double(finalGrade.finalGrade)
                    fourthLowestName = finalGrade.name
                }
            } else {
                fifthLowest = Double(finalGrade.finalGrade)
                fifthLowestName = finalGrade.name
            }
        }
    }
    print("Top 5 lowest final grades in the whole class: ")
    print("\(fifthLowestName)'s Final Grade: \(fifthLowest)")
    print("\(fourthLowestName)'s Final Grade: \(fourthLowest)")
    print("\(thirdLowestName)'s Final Grade: \(thirdLowest)")
    print("\(secondLowestName)'s Final Grade: \(secondLowest)")
    print("\(lowestGradeName)'s Final Grade: \(lowestFinalGrade)")
}

// Displays the 5 highest final grades in the whole class
func highestFinalGrades () {
    var highestFinalGrade: Double = 0
    var highestGradeName: String = ""
    
    var secondHighest: Double = 0
    var secondHighestName: String = ""
    
    var thirdHighest: Double = 0
    var thirdHighestName: String = ""
    
    var fourthHighest: Double = 0
    var fourthHighestName: String = ""
    
    var fifthHighest: Double = 0
    var fifthHighestName: String = ""
    
    for finalGrade in students {
            
        if Double(finalGrade.finalGrade) > fifthHighest {
            if Double(finalGrade.finalGrade) > fourthHighest {
                if Double(finalGrade.finalGrade) > thirdHighest {
                    if Double(finalGrade.finalGrade) > secondHighest {
                        if Double(finalGrade.finalGrade) > highestFinalGrade {
                            fifthHighest = fourthHighest
                            fifthHighestName = fourthHighestName
                            
                            fourthHighest = thirdHighest
                            fourthHighestName = thirdHighestName
                            
                            thirdHighest = secondHighest
                            thirdHighestName = secondHighestName
                            
                            secondHighest = highestFinalGrade
                            secondHighestName = highestGradeName
                            
                            highestFinalGrade = Double(finalGrade.finalGrade)
                            highestGradeName = finalGrade.name
                        } else {
                            fifthHighest = fourthHighest
                            fifthHighestName = fourthHighestName
                            
                            fourthHighest = thirdHighest
                            fourthHighestName = thirdHighestName
                            
                            thirdHighest = secondHighest
                            thirdHighestName = secondHighestName
                            
                            secondHighest = Double(finalGrade.finalGrade)
                            secondHighestName = finalGrade.name
                        }
                    } else {
                        fifthHighest = fourthHighest
                        fifthHighestName = fourthHighestName
                        
                        fourthHighest = thirdHighest
                        fourthHighestName = thirdHighestName
                        
                        thirdHighest = Double(finalGrade.finalGrade)
                        thirdHighestName = finalGrade.name
                    }
                } else {
                    fifthHighest = fourthHighest
                    fifthHighestName = fourthHighestName
                    
                    fourthHighest = Double(finalGrade.finalGrade)
                    fourthHighestName = finalGrade.name
                }
            } else {
                fifthHighest = Double(finalGrade.finalGrade)
                fifthHighestName = finalGrade.name
            }
        }
    }
    print("Top 5 higest final grades in the whole class: ")
    print("\(fifthHighestName)'s Final Grade: \(fifthHighest)")
    print("\(fourthHighestName)'s Final Grade: \(fourthHighest)")
    print("\(thirdHighestName)'s Final Grade: \(thirdHighest)")
    print("\(secondHighestName)'s Final Grade: \(secondHighest)")
    print("\(highestGradeName)'s Final Grade: \(highestFinalGrade)")
}
// Displays grades that is within the minimum and maximum grade ranges
// Purposely set the inRangeGrades as a 2D Array. This helps identify what grades belongs to who.
func gradeRange (minimum: String, maximum: String) {
    if minimum == "None" {
        print("Please input a number for the minimum range.")
        print("")
        
        if let userInput = readLine() {
            gradeRange(minimum: userInput, maximum: "None")
        }
    } else if maximum == "None" {
        print("Now enter a number for the maximum range.")
        print("")
        
        if let userInput = readLine() {
            gradeRange(minimum: minimum, maximum: userInput)
        }
    } else {
        if (Int(minimum) == nil) {
            print("ERROR: there has been a problem with what you've inputted as your minimum. Please re-input the numbers you wanna enter in.")
            
            gradeRange(minimum: "None", maximum: maximum)
        }
        if (Int(maximum) == nil) {
            print("ERROR: there has been a problem with what you've inputted as your maximum. Please re-input the numbers you wanna enter in.")
            
            gradeRange(minimum: minimum, maximum: "None")
        }
        
        gradeRangeData(min: Int(minimum)!, max: Int(maximum)!)
    }
}
// Second part of the gradeRange function which loops until the end of the row of grades.
// Then appends the tempArrayHolder into the inRangeGrades to show which grades belongs to who that is in the range the teacher puts in.
func gradeRangeData (min: Int, max: Int) {
    var inRangeGrades: [[String]] = []
    for grades in students {
        var tempArrayHolder: [String] = []
        for grade in grades.grades {
            if Int(grade)! > min && Int(grade)! < max {
                tempArrayHolder.append(grade)
            }
        }
        //            if Int(grade)! > min && Int(grade)! < max {
        //                tempArrayHolder.append(grade)
        //            }
        inRangeGrades.append(tempArrayHolder)
        
    }
    print(inRangeGrades)
}
// Quits the program. Simple as that. Unless...
func quitProgram () {
    print("Very well then.")
    print("We will meet again for these grade Professor Gomez.")
    print("Please, have a good time here and with the students.")
    
}
