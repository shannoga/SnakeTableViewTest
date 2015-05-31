//
//  SnakeTableViewController.swift
//  SnakeTableViewTest
//
//  Created by Shani LTG on 5/19/15.
//  Copyright (c) 2015 Shani LTG. All rights reserved.
//

import UIKit

class SnakeTableViewController: UITableViewController {
    
    
    enum UIUserInterfaceIdiom : Int {
        case Unspecified
        case Phone // iPhone and iPod touch style UI
        case Pad // iPad style UI
    }
    
    @IBOutlet weak var filterController: UISegmentedControl!
    @IBOutlet weak var currentLessonSteper: UIStepper!
    @IBOutlet weak var lessonLabel: UILabel!
    
    
    
    var maxLessonsInRow = 4
    var currentLessonIndex = 3
    var snakeContinuousLineColor = UIColor.mainSnakeColor()
    var snakeDashedColor = UIColor.lightGrayColor()
    var lessonViewColor = UIColor.mainSnakeColor()

    lazy var lessons = Array<Lesson>()

    private var isOddLessonsCell = false
    private var openDataCell = false
    private var openedDataCellIndexPath:NSIndexPath? = NSIndexPath()
    private var activeLessonsFilterType:Lesson.LessonType =  Lesson.LessonType.None
    private var cellsLessonRanges = Array<Range<Int>>()

    
    @IBAction func changeCurrentLesson(sender: UIStepper) {
        self.currentLessonIndex = Int(sender.value)
        self.tableView.reloadData()
        lessonLabel.text = "\(Int(sender.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle =  UITableViewCellSeparatorStyle.None
      
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.tableView.rowHeight = 180
            maxLessonsInRow = 3
        } else {
            self.tableView.rowHeight = 180
            maxLessonsInRow = 3
        }
        
        createStubLessons()
        storeCellsLessonRanges()
        
        //steper
        currentLessonSteper.tintColor = UIColor.mainSnakeColor()
        filterController.tintColor = UIColor.mainSnakeColor()
        
        currentLessonSteper.minimumValue = 0
        currentLessonSteper.maximumValue = Double(self.cellsLessonRanges.count)
        currentLessonSteper.value = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsLessonRanges.count * 2
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row % 2 != 0
        {
            if let candidateIndexPath = openedDataCellIndexPath
            {
                if candidateIndexPath == indexPath
                {
                    return self.tableView.frame.size.height - self.tableView.rowHeight
                }
                else
                {
                    return 0.0
                }
            }
            else
            {
                return 0
            }
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {//lessons cell
            //even row
            let cell: SnakeTableViewCell

            if indexPath.row % 4 == 0 {
                cell = self.tableView.dequeueReusableCellWithIdentifier("shortCell") as! SnakeTableViewCell
                cell.lessonInRow = maxLessonsInRow - 1
                cell.isEvenRow = true
            }
            else
            {
                cell = self.tableView.dequeueReusableCellWithIdentifier("longCell") as! SnakeTableViewCell
                cell.lessonInRow = maxLessonsInRow
                cell.isEvenRow = false

            }
            
        
            cell.lessonsIndexRange = cellsLessonRanges[indexPath.row/2]
            cell.currentLessonIndex = currentLessonIndex
            var cellLessonsSlice = self.lessons[cell.lessonsIndexRange]
            cell.lessons = (indexPath.row % 4 == 0) ? Array(cellLessonsSlice) : Array(cellLessonsSlice).reverse()
            
            cell.snakeContinuousLineColor = snakeContinuousLineColor
            cell.snakeDashedColor = snakeDashedColor
            cell.lessonViewColor = lessonViewColor
            
            cell.isLastCell = (indexPath.row) >= (self.tableView.numberOfRowsInSection(indexPath.section) - 2)
            
            cell.setUpLessonsSqueurs()
            cell.updateLessonsData()
            cell.filterLessonOfType(self.activeLessonsFilterType, animated:false)

            
            return cell

        }else { //data cell
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("lessonDataCell") as! UITableViewCell
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //openDataCell = true
        if let index = openedDataCellIndexPath
        {
            openedDataCellIndexPath = nil
            closeDataCellAtIndexPath(index)
        }
        else
        {
            openedDataCellIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            openDataCellAtIndexPath(openedDataCellIndexPath!)
            super.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    
    // MARK: Filtering
    @IBAction func filterTapped(sender: UISegmentedControl) {
        
        let lessonType = Lesson.LessonType(rawValue: sender.selectedSegmentIndex)!
        for (index, cell) in enumerate(self.tableView.visibleCells()) {
            if let lessonCell = cell as? SnakeTableViewCell  {
                self.activeLessonsFilterType = lessonType
                lessonCell.filterLessonOfType(lessonType, animated: true)
            }
        }
        scrollToCurrentLesson()
    }
    
    func scrollToCurrentLesson() {
        self.tableView.scrollToRowAtIndexPath(cellIndexPathForLessonIndex(currentLessonIndex), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    // MARK: Lesson indexes
    func createStubLessons() {
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CA", imageName: "cat", subTitle: "Cats are horrible"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"DO", imageName: "dog", subTitle: "Dogs"))
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CA", imageName: "cat", subTitle: "Cats are horrible"))
        lessons.append(Lesson(lessonType: .Quant, initials:"CHI", imageName: "chicken", subTitle: "You are a chicken"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"DO", imageName: "dog", subTitle: "Dogs"))
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CA", imageName: "cat", subTitle: "Cats are horrible"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"DO", imageName: "dog", subTitle: "Dogs"))
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CA", imageName: "cat", subTitle: "Cats are horrible"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"DO", imageName: "dog", subTitle: "Dogs"))
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CA", imageName: "cat", subTitle: "Cats are horrible"))
        lessons.append(Lesson(lessonType: .Quant, initials:"CHI", imageName: "chicken", subTitle: "You are a chicken"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"DO", imageName: "dog", subTitle: "Dogs"))
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CA", imageName: "cat", subTitle: "Cats are horrible"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"DO", imageName: "dog", subTitle: "Dogs"))
        lessons.append(Lesson(lessonType: .Quant, initials:"ELEP", imageName: "elephant", subTitle: "Elephants are huge"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"CO", imageName: "cow", subTitle: "Cows are stupid"))
        lessons.append(Lesson(lessonType: .Quant, initials:"HOR", imageName: "horse", subTitle: "Horeses"))
        lessons.append(Lesson(lessonType: .Verbal, initials:"PI", imageName: "pig", subTitle: "Miss pigi"))
    }
    
    func storeCellsLessonRanges() {
        
        var lessonsPerRow = maxLessonsInRow - 1
        var cellRow = 0
        var location = 0
        while location < self.lessons.count
        {
            var stop = false
            
            var lessonRange = location...location + lessonsPerRow - 1
            
            for index in lessonRange {
                if index >= lessons.count && !stop {
                    println("index \(index) dose not exists in lseeons")
                    lessonRange.endIndex = index
                    stop = true
                }
            }
            cellsLessonRanges.insert(lessonRange, atIndex: cellRow)
            
            location += lessonsPerRow
            lessonsPerRow = (lessonsPerRow < maxLessonsInRow) ? maxLessonsInRow  : maxLessonsInRow - 1
            cellRow++
            
        }
    }

    func lessonViewsRangeForCellAtRealIndex(index:Int) -> Range<Int> {
        
        let cellsToSubstruct = ((index % 2 != 0) ? index/2 : (index + 1)/2) + 2
        var maxIndexForCell = ((index + 1) * maxLessonsInRow) - cellsToSubstruct
        var minIndexForCell = maxIndexForCell - (maxLessonsInRow - ((index % 2 == 0) ?  2 : 1))
        var range = minIndexForCell...maxIndexForCell
        return range
    }
    
    func cellIndexPathForLessonIndex(lessonIndex:Int) -> NSIndexPath {
        var rawIndex = 0
        for (index, range) in enumerate(self.cellsLessonRanges) {
            if range.contains(lessonIndex)
            {
                rawIndex = index * 2
                break
            }
        }
        return NSIndexPath(forRow: rawIndex, inSection: 0)
    }
    
    // MARK: Open lesson navigator
    func openDataCellAtIndexPath(indexPath:NSIndexPath) {
        tableView.scrollEnabled = false
        tableView.beginUpdates()
        super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        tableView.endUpdates()
    }
    
    func closeDataCellAtIndexPath(indexPath:NSIndexPath) {
        tableView.scrollEnabled = true
        
        tableView.beginUpdates()
        super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        tableView.endUpdates()
    }
    
    func isCellContainsCurrentLessonView(cell:SnakeTableViewCell) -> Bool {
        return cell.lessonsIndexRange.contains(self.currentLessonIndex)
    }
    
}
