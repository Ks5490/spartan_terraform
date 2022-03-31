import json
from flask import Flask, request
from spartan import Spartan
import pymongo
from pymongo import MongoClient
import requests


def get_ip_address():
    link = "http://ipv4.icanhazip.com"
  
    ip = requests.get(link)
   
   

### Adds employee to mongo database ###
def add_employee():
    ip = get_ip_address()
    cluster = MongoClient(f"mongodb://{ip}:27017")
    db = cluster["spartan"]
    collection = db["spartan_data"]


    ### Reading in User input (POST)
    employee_data = request.json
    First_name = employee_data["first name"]
    Last_name = employee_data["Last Name"]
    employee_id = employee_data["Employee ID"]
    birth_year = employee_data["Birth Year"]
    birth_month = employee_data["Birth Month"]
    birth_day = employee_data["Birth Day"]
    course = employee_data["Course"]
    stream = employee_data["Stream"]


    ### Validation of User input ###
    validation_ID = Spartan.ID_validation(employee_id)
    if validation_ID != "v":
        return "Failed ID Validation - Must contain an integer"

    validation_first_name = Spartan.first_last_name_validation(First_name)
    if validation_first_name != "v":
        return "Failed First Name Validation - Must contain minimum of 2 characters"

    validation_last_name = Spartan.first_last_name_validation(Last_name)
    if validation_last_name != "v":
        return "Failed Last Name Validation - Must contain minimum of 2 characters"

    validation_year_of_birth = Spartan.year_validation(birth_year)
    if validation_year_of_birth != "v":
        return "Failed Year of Birth Validation - Must be an integer between 1900 - 2004"

    validation_month_of_birth = Spartan.month_validation(birth_month)
    if validation_month_of_birth != "v":
        return "Failed Month of Birth Validation - Must be an integer between 1 - 12"

    validation_day_of_birth = Spartan.day_validation(birth_day)
    if validation_day_of_birth != "v":
        return "Failed Day of Birth Validation - Must be an integer between 1 - 31"

    validation_course = Spartan.stream_course_validation(course)
    if validation_course != "v":
        return "Failed Course Validation - Must be a non empty string"

    validation_stream = Spartan.stream_course_validation(stream)
    if validation_stream != "v":
        return "Failed Stream Validation - Must be a non empty string"
    
    try:
        post = {"_id": employee_id,"First Name" : First_name, "Last Name" : Last_name, "Birth Year" : birth_year, "Birth Month" : birth_month, "Birth day" : birth_day, "Course" : course, "Stream" : stream}
        collection.insert_one(post)

    except Exception as ex:
        return str(ex)
        

    return f"Added employee {First_name} {Last_name} to the database"

#### Shows specifc Spartan Data ###
def show_spartan(spartan_id):
    ip = get_ip_address()
    cluster = MongoClient(f"mongodb://{ip}:27017")
    db = cluster["spartan"]
    collection = db["spartan_data"]

    result = collection.find_one({"_id" : spartan_id})

    if not result:
        return "No employee with this ID"
    else:
        return result
        

### Removes data entry at selected ID ###

def remove_employee(sparta_id):
    ip = get_ip_address()
    cluster = MongoClient(f"mongodb://{ip}:27017")
    db = cluster["spartan"]
    collection = db["spartan_data"]
   
    result = collection.find_one({"_id" : sparta_id})

    if not result:
        return "No employee with this ID"
    else:
        collection.delete_one({"_id" : sparta_id })
        return "Employee deleted"


### Shows all Spartan Data ###
def show_spartan_list_json():
    ip = get_ip_address()
    cluster = MongoClient(f"mongodb://{ip}:27017")
    db = cluster["spartan"]
    collection = db["spartan_data"]

    results = collection.find({})
    a = []
    for result in results:
        a.append(result)


    b = str(a)

    return b