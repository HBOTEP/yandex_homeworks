//
//  TodoItemTests.swift
//  TodoTests
//
//  Created by Анастасия on 22.06.2024.
//

import XCTest

@testable
import Todo

final class TodoItemTests: XCTestCase {
    // MARK: - Done ordinary item with modification date
    func testItemCreation() {
        let testModificationDate = Date()
        let testItem = TodoItem(
            text: "Test",
            importance: .ordinary,
            done: true,
            modificationDate: testModificationDate
        )
        
        XCTAssertEqual(testItem.text, "Test")
        XCTAssertEqual(testItem.importance, .ordinary)
        XCTAssertNil(testItem.deadline)
        XCTAssertTrue(testItem.done)
        XCTAssertEqual(testItem.modificationDate, testModificationDate)
    }
    
    // MARK: - Not completed important item with deadline
    func testImportantItemCreation() {
        let testDeadline = Date().addingTimeInterval(3600)
        let testItem = TodoItem(text: "Test", importance: .important, deadline: testDeadline)
        
        XCTAssertEqual(testItem.text, "Test")
        XCTAssertEqual(testItem.importance, .important)
        XCTAssertEqual(testItem.deadline, testDeadline)
        XCTAssertFalse(testItem.done)
        XCTAssertNil(testItem.modificationDate)
    }
    
    // MARK: - JSON Serialization
    func testJsonSerialization() {
        let todoItem = TodoItem(
            id: "1",
            text: "Test",
            importance: .important,
            deadline: nil,
            done: false,
            creationDate: Date(),
            modificationDate: nil,
            hex: "000000"
        )
        
        guard let jsonData = todoItem.json as? Data else {
            XCTFail("Failed to serialize TodoItem to JSON")
            return
        }
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail("Failed to parse JSON")
            return
        }
        
        XCTAssertEqual(jsonObject["id"] as? String, todoItem.id)
        XCTAssertEqual(jsonObject["text"] as? String, todoItem.text)
        XCTAssertEqual(jsonObject["done"] as? Bool, todoItem.done)
        XCTAssertNotNil(jsonObject["creationDate"])
        XCTAssertEqual(jsonObject["importance"] as? String, todoItem.importance.rawValue)
        XCTAssertEqual(jsonObject["hex"] as? String, todoItem.hex)
    }
    
    // MARK: - JSON Deserialization
    func testJsonDeserialization() {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        let creationDate = Date()
        
        let jsonString = """
            {
                "id": "1",
                "text": "Test task",
                "importance": "important",
                "done": false,
                "creationDate": "\(formatter.string(from: creationDate))",
                "hex": "000000"
            }
            """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to deserialize JSON")
            return
        }
        
        guard let todoItem = TodoItem.parse(json: jsonData) else {
            XCTFail("Failed to parse JSON")
            return
        }
        
        XCTAssertEqual(todoItem.id, "1")
        XCTAssertEqual(todoItem.text, "Test task")
        XCTAssertEqual(todoItem.importance, .important)
        XCTAssertEqual(todoItem.done, false)
        XCTAssertEqual(
            todoItem.creationDate.timeIntervalSinceReferenceDate,
            creationDate.timeIntervalSinceReferenceDate,
            accuracy: 1.0
        )
        XCTAssertEqual(todoItem.hex, "000000")
    }
    
    // MARK: - CSV Serialization
    func testCsvSerialization() {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        let creationDate = Date()
        
        let todoItem = TodoItem(
            id: "1",
            text: "Test, task",
            importance: .important,
            deadline: nil,
            done: false,
            creationDate: creationDate,
            modificationDate: nil,
            hex: "000000"
        )
        
        let csvString = todoItem.csv
        
        var expectedCsv = [
            todoItem.id,
            "\"Test, task\"",
            "important",
            "",
            "false",
            formatter.string(from: creationDate),
            "000000",
            "",
            ""
        ].joined(separator: ",")
        
        expectedCsv.removeLast()
        
        XCTAssertEqual(csvString, expectedCsv)
    }
    
    // MARK: - CSV Deserialization
    func testCsvDeserialization() {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        let creationDate = Date()
        let deadline = Calendar.current.date(byAdding: .day, value: 1, to: creationDate)
        let modificationDate = Calendar.current.date(byAdding: .hour, value: 1, to: creationDate)
        
        let csvString = """
            1,"Test, task",important,\(formatter.string(from: deadline!)),false,\(formatter.string(from: creationDate)),000000,\(formatter.string(from: modificationDate!))
            """
        
        guard let todoItem = TodoItem.parse(csv: csvString) else {
            XCTFail("Failed to parse TodoItem from CSV string")
            return
        }
        
        XCTAssertEqual(todoItem.id, "1")
        XCTAssertEqual(todoItem.text, "Test, task")
        XCTAssertEqual(todoItem.importance, .important)
        XCTAssertEqual(
            todoItem.deadline!.timeIntervalSinceReferenceDate,
            deadline!.timeIntervalSinceReferenceDate,
            accuracy: 1.0
        )
        XCTAssertEqual(todoItem.done, false)
        XCTAssertEqual(
            todoItem.creationDate.timeIntervalSinceReferenceDate,
            creationDate.timeIntervalSinceReferenceDate,
            accuracy: 1.0
        )
        XCTAssertEqual(todoItem.hex, "000000")
        XCTAssertEqual(
            todoItem.modificationDate!.timeIntervalSinceReferenceDate,
            modificationDate!.timeIntervalSinceReferenceDate,
            accuracy: 1.0
        )
    }
}
