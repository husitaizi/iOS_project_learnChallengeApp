//
//  AppDelegate.swift
//  Project
//
//  Created by  on 2023-03-14.
//

import UIKit
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var savedUsername = ""
    var savedEmail = ""
    var savedPassword = ""

    // properties for the database use
    var databaseName:String? = "iOS_project.sqlite"
    
    // databasePath refers to the directory in the emulator
    var databasePath:String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // specify the document directory in the emulaor | iPhone | devices
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        // dir
        let documentDir = documentPaths[0]
        databasePath = documentDir.appending("/" + databaseName!)
        
        //check the existence of database on the device, if NOT exist copy it from the App dir
        checkAndCreateDatabase()
        
        
        return true
    }

    //check if the database exist, if not copy it from app to devices
    func checkAndCreateDatabase(){
         
        var success = false
        
        // define fileManager
        let fileManager = FileManager.default
        
        //check if there is databse file of the same name in the (emulated)device
        success = fileManager.fileExists(atPath: databasePath!)
        
        // if the database exists, do nothing
        if success {
            return
        }
        
        // the database.db file in the App
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        //coopy the database from app dir to device
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        // *** important: return to didFinishLaunching
        return
    }
    
    /**
     verify the user's login info
     take email and password as parameters
     retrieve the user infor as to the input email
     compare the input password with the saved password
    
     */
    func verifyLogintInfo(inputEmail:String,inputPassword:String) -> Bool{
        
        //Opaque pointers are used to represent C pointers to types that
        // cannot be represented in Swift, such as incomplete struct types.
        var db:OpaquePointer? = nil

        
        // build a connection
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement:OpaquePointer? = nil
            let queryStatementString:String = "select * from users where email = \(inputEmail)"
            
            /* Database handle */
            /* SQL statement, UTF-8 encoded */
            /* Maximum length of zSql in bytes. */
            /* OUT: Statement handle */
            /* OUT: Pointer to unused portion of zSql */
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    // in c language
                    let cusername = sqlite3_column_text(queryStatement, 0)
                    let cemail = sqlite3_column_text(queryStatement, 1)
                    let cpassword = sqlite3_column_text(queryStatement, 4)

                    // convert
                    savedUsername = String(cString: cusername!)
                    savedEmail = String(cString: cemail!)
                    savedPassword = String(cString: cpassword!)
                    
                    print(
                        "query result \n" + "\(savedUsername) | \(savedEmail) | \(savedPassword) "
                    )
                }
                //clean up
                sqlite3_finalize(queryStatement)
            }
            else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        }
        // verify email and password
        if inputEmail == savedEmail && inputPassword == savedPassword {
            return true
        } else {
            return false
        }
    }
    
    //insertIntoDatabase and return succeed or NOT
    func insertIntoDatabase(user:User) -> Bool {
        // define sqlite3 object to interact with db
        var db:OpaquePointer? = nil
        var returnCode:Bool = true
        
        // open connection to db file
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            // setup query
            var insertStatement:OpaquePointer? = nil
            let insertStatementString:String = "insert into users values(?,?,?,?,?)"
            
            //setup object that will handle data transfer
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                // need to cast into nsobject to be able to convert to utf8string
                let usernameStr = user.userName! as NSString
                let emailStr = user.email! as NSString
                let passwordStr = user.password! as NSString
                let birthdayStr = user.birthday! as NSString
                let levelInt = user.level! as NSInteger
               
                
                sqlite3_bind_text(insertStatement,0,usernameStr.utf8String,-1,nil)
                sqlite3_bind_text(insertStatement, 1, emailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, birthdayStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 3,Int32(levelInt))
                sqlite3_bind_text(insertStatement, 4, passwordStr.utf8String, -1, nil)
                
                //execute query
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row.\(rowID)")
                } else {
                    print("Could not insert now")
                    returnCode = false
                }
                //clean up
                sqlite3_finalize(insertStatement);
            }
            else {
                print("INSERT statement could not be prepared.")
                returnCode = false
            }
            //close db connection
            sqlite3_close(db)
        }
        else {
            print("Unable to open database.")
            returnCode = false
        }
        
        return returnCode
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

