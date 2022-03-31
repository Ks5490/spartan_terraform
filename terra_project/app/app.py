from flask import Flask, jsonify, request, render_template
import json
import managment
import os 

app = Flask(__name__)




### Home page route ###
@app.route("/", methods = ["GET"])
def home_page():
    return """
    <center>
    <h1 style='color: blue;'>Welcome to my first sparta project</h1>
    <p>APIs (Application Programming Interface) is an intermediary that enables applications to communicate with each other</p>
    <p>This API is designed to allow the user to interact with the Sparta Employee Database (Using a JSON file)</p>
    <p>The User can interact with the application by directly copying and pasting the url link for any of the <b style='color: blue'>GET</b> routes below:</p>
    <p>---route: /spartan/<spartan_id>     | This route will allow the User to see the data of a spartan employee with the input employee ID </p>
    <p>---route: /spartan     | This route will allow the User to see the entire spartan employee database</p>
    <p>The User can also manipulate the database itself using the <b style='color: red'>POST</b> routes below (Using an application like POSTMAN):</p>
    <p>---route: /spartan/add     | This route allows the user to add an employee provided they pass the input validation</p>
    <p>---route: /spartan/remove?id=sparta_id     | This route allows the user to remove an employee from the database with the employee ID</p>
    </center>
    """
    

### Adding employee route (POST) ###
@app.route("/spartan/add", methods = ['POST'])
def additiion_of_employee_POST():
    return managment.add_employee()


### Displays specifc Spartan Data ###
@app.route("/spartan/<spartan_id>", methods = ["GET"])
def show_spartan_page(spartan_id):
    return managment.show_spartan(spartan_id)


### Removes specifc Spartan Data ###
@app.route("/spartan/remove", methods = ["POST"])
def remove_employee_POST():
    iden_variable = request.args.get("sparta_id")
    sparta_id_str = str(iden_variable)
    return managment.remove_employee(sparta_id_str)
        

### Displays all Spartan Data ###
@app.route("/spartan", methods = ["GET"])
def show_spartan_list_json_page():
    return managment.show_spartan_list_json()


### Start of Main ###
if __name__ == "__main__":
        
        app.run(host='0.0.0.0' , port = 8080)

   