//
//  HealthTable.swift
//  Ygeia
//
//  Created by mohamed hisham on 5/29/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit
import HealthKit
import ContactsUI

class HealthTable: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spaceToBottom: NSLayoutConstraint!
    //MARK :- Declarations
    var attributesArray:[String]=[]
    var valuesArray:[String:String]=[:]
    var pickerData: [String] = [String]()
    var userData = User()
    var userImage=UIImage()
    var userDefaults=UserDefaults(suiteName: "group.Ygeia")
    var contactsArray: [String]=[]
    var expanded = false
    
    //    enum cells {
    //        case editLabel = "EditLabelCell"
    //        var nib: UINib {
    //             return UINib(nibName: self.id, bundle: nil)
    //        }
    //        var id: String {
    //           return self.rawValue
    //        }
    //    }
    
    var reuseId = "LabelCell"
    var homeNib = UINib(nibName: "LabelCell", bundle: nil)
    var reuseIdEdit = "EditLabelCell"
    var homeNibEdit = UINib(nibName: "EditLabelCell", bundle: nil)
    var reuseIdc = "CubicCell"
    var homeNibc = UINib(nibName: "CubicCell", bundle: nil)
    var reuseIdw = "WaterCell"
    var healthStore = HKHealthStore()
    var homeNibw = UINib(nibName: "WaterCell", bundle: nil)
    var reuseIdBlood = "BloodTypeEditCell"
    var homeNibBlood = UINib(nibName: "BloodTypeEditCell", bundle: nil)
    var reuseIdImage = "imageCell"
    var homeNibImage = UINib(nibName: "imageCell", bundle: nil)
    var reuseIdText = "BigTextCell"
    var homeNibText = UINib(nibName: "BigTextCell", bundle: nil)
    var reuseIdCo = "ContactsCell"
    var homeNibCo = UINib(nibName: "ContactsCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializations()
        configtableview ()
        healthKitStuff()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        //Do something here
        print ("keyboard opened")
        spaceToBottom.constant=250
    }
    
    @objc func keyboardWillDisappear() {
        //Do something here
        print ("closed")
        spaceToBottom.constant=0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func intializations(){
        
        if let data = userDefaults?.object(forKey: "image")
        {
            self.userImage = UIImage(data: data as! Data)!
            print("loading image success")
            
        }
        contactsArray = userDefaults?.stringArray(forKey: "array") ?? [String]()
        attributesArray=["","Name", "Age","Blood Type","Weight","Height","","Emergency Contact" , "Medical Condition" ,"Medical Notes", "Allergies","Medications","Location","Hospitals","General Notes","User photo"]
        
        valuesArray = ["":"","Name":"", "Age":"","Blood Type":"","Weight":"","Height":"","Emergency Contact":"" , "Medical Condition":"" ,"Medical Notes":"", "Allergies":"","Medications":"","Location":"","Hospitals":"","General Notes":"","User photo":""]
        
        pickerData = ["Not set", "A+", "A-", "B+", "B-", "AB+","AB-","O+","O-"]
        
        let decoder = JSONDecoder()
        if let userD = userDefaults!.data(forKey: "user"),
            let userr = try? decoder.decode(User.self, from: userD) {
            userData = userr
            print(userData.allergies)
            print(userData.name)
        }
        valuesArray["Name"] = userData.name
        valuesArray["Age"] = userData.age
        valuesArray["Height"]=userData.height
        valuesArray["Weight"] = userData.weight
        valuesArray["Blood Type"] = userData.bloodType
        valuesArray["Allergies"]=userData.allergies
        valuesArray["Emergency Contact"]=userData.emergencyContact
        valuesArray["Hospitals"]=userData.hospitals
        valuesArray["Medical Condition"]=userData.medicalCondition
        valuesArray["Medications"]=userData.medications
        valuesArray["General Notes"]=userData.generalNotes
        valuesArray["Medical Notes"]=userData.medicalNotes
        tableView.reloadData()
    }
    func configtableview () {
        tableView.register(homeNib, forCellReuseIdentifier:reuseId)
        tableView.register(homeNibc, forCellReuseIdentifier:reuseIdc)
        tableView.register(homeNibw, forCellReuseIdentifier:reuseIdw)
        tableView.register(homeNibEdit, forCellReuseIdentifier:reuseIdEdit)
        tableView.register(homeNibBlood, forCellReuseIdentifier:reuseIdBlood)
        tableView.register(homeNibText, forCellReuseIdentifier:reuseIdText)
        tableView.register(homeNibImage, forCellReuseIdentifier:reuseIdImage)
        tableView.register(homeNibCo, forCellReuseIdentifier:reuseIdCo)
        
        self.tableView.separatorStyle = .none
        self.tableView.bounces=false
        self.navigationItem.title = ""
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        navigationItem.rightBarButtonItem = editButtonItem
        
    }
    @objc func dismissKey(){
        view.endEditing(true)
    }
    func healthKitStuff(){
        guard let allergiesType = HKObjectType.clinicalType(forIdentifier: .allergyRecord),
            let medicationsType = HKObjectType.clinicalType(forIdentifier: .medicationRecord) else {
                fatalError("*** Unable to create the requested types ***")
        }
        if HKHealthStore.isHealthDataAvailable() {
            
            let allTypes = Set([HKObjectType.quantityType(forIdentifier: .height)!,
                                HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                                HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                                HKObjectType.characteristicType(forIdentifier: .bloodType)!,
                                HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
                ])
            
            healthStore.requestAuthorization(toShare: nil, read: [allergiesType, medicationsType]) { (success, error) in
                if (success){
                    print("asdasd")
                    let allergyQuery = HKSampleQuery(sampleType: allergiesType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                        
                        guard let actualSamples = samples else {
                            // Handle the error here.
                            print("*** An error occurred: \(error?.localizedDescription ?? "nil") ***")
                            return
                        }
                        
                        let allergySamples = actualSamples as? [HKClinicalRecord]
                        // Do something with the allergy samples here...
                        print(allergySamples as Any)                    }
                    
                    self.healthStore.execute(allergyQuery)
                }
               
                guard success else {
                    // Handle errors here.
                    fatalError("*** An error occurred while requesting authorization: \(error!.localizedDescription) ***")
                }
            }
            
             print("ay 7aga")
            
            
            healthStore.requestAuthorization(toShare: nil, read: allTypes) {(success, error) in
                
                do{
                    print("iam here ")
                    let userAgeSexAndBloodType = try self.getAgeSexAndBloodType()
                    print(userAgeSexAndBloodType.age,userAgeSexAndBloodType.bloodType,userAgeSexAndBloodType.biologicalSex.rawValue)
                    
                    self.valuesArray["Age"]=String(userAgeSexAndBloodType.age)
                    self.userData.bloodType=String(userAgeSexAndBloodType.bloodType.rawValue)
                    self.valuesArray["Blood Type"]=String(userAgeSexAndBloodType.bloodType.rawValue)
                    
                    guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
                        print("Height Sample Type is no longer available in HealthKit")
                        return
                    }
                    self.getMostRecentSample(for: heightSampleType) { (sample, error) in
                        
                        
                        let heightInMeters = (sample as? HKQuantitySample)!.quantity.doubleValue(for: HKUnit.meter())
                        print(heightInMeters)
                        
                        self.valuesArray["Height"]=String(heightInMeters)
                        self.tableView.reloadData()
                    }
                    
                    guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
                        print("Body Mass Sample Type is no longer available in HealthKit")
                        return
                    }
                    
                    self.getMostRecentSample(for: weightSampleType) { (sample, error) in
                        
                        guard let sample = sample else {
                            
                            if error != nil {
                                
                                
                            }
                            return
                        }
                        
                        let weightInKilograms = (sample as? HKQuantitySample)! .quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                        print(weightInKilograms)
                        
                        self.valuesArray["Weight"]=String(weightInKilograms)
                        self.tableView.reloadData()
                    }
                    
                } catch _ {
                    // print(error)
                    
                }
                
                
                
                
            }
            
        }
        
    }
    
    func getAgeSexAndBloodType() throws -> (age: Int,
        biologicalSex: HKBiologicalSex,
        bloodType: HKBloodType) {
            
            
            
            do {
                
                
                let birthdayComponents =  try healthStore.dateOfBirthComponents()
                let biologicalSex =       try healthStore.biologicalSex()
                let bloodType =           try healthStore.bloodType()
                
                
                let today = Date()
                let calendar = Calendar.current
                let todayDateComponents = calendar.dateComponents([.year,.month],
                                                                  from: today)
                let thisYear = todayDateComponents.year!
                var age = thisYear - birthdayComponents.year!
                if (birthdayComponents.month! > todayDateComponents.month!){
                    age-=1
                }
                let unwrappedBiologicalSex = biologicalSex.biologicalSex
                let unwrappedBloodType = bloodType.bloodType
                
                return (age, unwrappedBiologicalSex, unwrappedBloodType)
            }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: true)
        if(isEditing){
            print("editing")
            
            tableView.reloadData()
        }else{
            
            
            print("done editing")
            tableView.reloadData()
        }
    }
    func getMostRecentSample(for sampleType: HKSampleType,
                             completion: @escaping (HKSample?, Error?) -> Swift.Void) {
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                                            
                                            DispatchQueue.main.async {
                                                
                                                guard let samples = samples,
                                                    let mostRecentSample = samples.first else {
                                                        
                                                        completion(nil, error)
                                                        return
                                                }
                                                
                                                completion(mostRecentSample, nil)
                                            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
}
extension HealthTable : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isEditing && (indexPath.row==7)){
            print("felt that")
            contactsStuff()
            
        }
        
        if (isEditing && (indexPath.row==15)){
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imag.allowsEditing = false
                self.present(imag, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(!isEditing){
            return drawCell(tableView, cellForRowAt: indexPath)}
        else{
            return editCell(tableView, cellForRowAt: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((indexPath.row == 1)||(indexPath.row == 2)||(indexPath.row == 4)||(indexPath.row == 5)){
            
            return 80
        }else if ( expanded && !isEditing && indexPath.row==7){
            return CGFloat(contactsArray.count*60)
        }else if( !expanded && indexPath.row==7){
            return 100
        }else
        {
            return 170}
    }
    func drawCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        if (indexPath.row == 0){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdc) as? CubicCell)!
            return currentCell
        } else if (indexPath.row == 6){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdw) as? WaterCell)!
            return currentCell
        }else if(indexPath.row==7){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdCo) as? ContactsCell)!
            currentCell.contacts=self.contactsArray
            currentCell.tableView.reloadData()
            currentCell.delegate=self
            return currentCell
        }
        else if ((indexPath.row == 1)||(indexPath.row == 2)||(indexPath.row == 4)||(indexPath.row == 5)||(indexPath.row == 3)){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseId) as? LabelCell)!
            currentCell.attribute?.text=attributesArray[indexPath.row]
            if (indexPath.row == 7){
                currentCell.value?.text="tap to view"
            }else{
                currentCell.value?.text=valuesArray[attributesArray[indexPath.row]]}
            return currentCell}
        else if (indexPath.row==15){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdImage) as? imageCell)!
            
            currentCell.profileImage.image=self.userImage
            return currentCell
        }else
        {
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdText) as? BigTextCell)!
            currentCell.Attribute?.text=attributesArray[indexPath.row]
            currentCell.textValue?.text=valuesArray[attributesArray[indexPath.row]]
            currentCell.textValue.delegate=self
            currentCell.textValue.isEditable=false
            return currentCell
        }
        
    }
    
    func contactsStuff(){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    func editCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        if (indexPath.row == 0){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdc) as? CubicCell)!
            return currentCell
        } else if (indexPath.row == 6){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdw) as? WaterCell)!
            return currentCell
        }else if (indexPath.row == 3){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdBlood) as? BloodTypeEditCell)!
            currentCell.picker.dataSource = self
            currentCell.picker.delegate = self
            return currentCell
        }
        else if ((indexPath.row == 1)||(indexPath.row == 2)||(indexPath.row == 4)||(indexPath.row == 5)){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdEdit) as? EditLabelCell)!
            currentCell.attribute?.text=attributesArray[indexPath.row]
            currentCell.value?.text=valuesArray[attributesArray[indexPath.row]]
            currentCell.delegate=self
            return currentCell}
        else if (indexPath.row == 7){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseId) as? LabelCell)!
            currentCell.attribute?.text=attributesArray[indexPath.row]
            currentCell.value?.text=valuesArray[attributesArray[indexPath.row]]
            return currentCell
            
        }
        else if (indexPath.row==15){
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdImage) as? imageCell)!
            currentCell.profileImage.image=self.userImage
            return currentCell
        }else
        {
            let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseIdText) as? BigTextCell)!
            currentCell.Attribute?.text=attributesArray[indexPath.row]
            currentCell.textValue?.text=valuesArray[attributesArray[indexPath.row]]
            currentCell.textValue.delegate=self
            currentCell.textValue.isEditable=true
            return currentCell
            
        }
        
        
        
    }}

extension HealthTable: EditCellDelegate {
    func editingDidEnd(cell: EditLabelCell) {
        print("delegate works")
        let indexPath = tableView.indexPath(for: cell)
        valuesArray[attributesArray[indexPath?.row ?? 0]]=cell.value?.text
        userData.name=valuesArray["Name"]
        userData.age=valuesArray["Age"]
        userData.height=valuesArray["Height"]
        userData.weight=valuesArray["Weight"]
        userData.bloodType=valuesArray["Blood Type"]
        userData.allergies=valuesArray["Allergies"]
        userData.emergencyContact=valuesArray["Emergency Contact"]
        userData.hospitals=valuesArray["Hospitals"]
        userData.medicalCondition=valuesArray["Medical Condition"]
        userData.medications=valuesArray["Medications"]
        userData.generalNotes=valuesArray["General Notes"]
        userData.medicalNotes=valuesArray["Medical Notes"]
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userData) {
            print(userData.allergies)
            userDefaults!.set(encoded, forKey: "user")
        }
        
        
    }
    
    
}
extension HealthTable:UIPickerViewDelegate, UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("here")
        valuesArray["Blood Type"]=pickerData[pickerView.selectedRow(inComponent: 0)]
        userData.bloodType=valuesArray["Blood Type"]
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userData) {
            print(userData.allergies)
            userDefaults!.set(encoded, forKey: "user")
        }
    }
}
extension HealthTable:UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        let cell = textView.superview?.superview?.superview as! BigTextCell
        valuesArray[cell.Attribute.text!]=textView.text
        userData.name=valuesArray["Name"]
        userData.age=valuesArray["Age"]
        userData.height=valuesArray["Height"]
        userData.weight=valuesArray["Weight"]
        userData.bloodType=valuesArray["Blood Type"]
        userData.allergies=valuesArray["Allergies"]
        userData.emergencyContact=valuesArray["Emergency Contact"]
        userData.hospitals=valuesArray["Hospitals"]
        userData.medicalCondition=valuesArray["Medical Condition"]
        userData.medications=valuesArray["Medications"]
        userData.generalNotes=valuesArray["General Notes"]
        userData.medicalNotes=valuesArray["Medical Notes"]
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userData) {
            print(userData.allergies)
            userDefaults!.set(encoded, forKey: "user")
        }
        
    }
    
}
extension HealthTable:EditContactslDelegate{
    func contactRemoved(index: Int) {
        contactsArray.remove(at: index)
        userDefaults?.set(contactsArray, forKey: "array")
    }
}

extension HealthTable:CNContactPickerDelegate{
    
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController,didSelect contacts: [CNContact]) {
        for contact in contacts {
            let userName:String = contact.givenName
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
            print(primaryPhoneNumberStr)
            self.contactsArray.append(primaryPhoneNumberStr)
        }
        //        valuesArray["Emergency Contact"]=primaryPhoneNumberStr
        //
        userDefaults?.set(contactsArray, forKey: "array")
        self.tableView.reloadData()
        
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}

extension HealthTable:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let key = UIImagePickerController.InfoKey.originalImage
        self.userImage = info[key] as! UIImage
        self.tableView.reloadData()
        let imageData:NSData = self.userImage.pngData()! as NSData
        userDefaults!.set(imageData, forKey: "image")
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension HealthTable : EditContactslCellDelegate{
    func expandCollpase(expanded: Bool) {
        self.expanded=expanded
        self.tableView.reloadData()
    }
    
    func contactRemovedCell(index: Int) {
        contactsArray.remove(at: index)
        userDefaults?.set(contactsArray, forKey: "array")
        self.tableView.reloadData()
    }
}



