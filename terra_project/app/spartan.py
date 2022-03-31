class Spartan:
    def __init__(self,spartan_id, first_name, last_name, birth_year, birth_month, birth_day, course, stream):
        self.spartan_id = spartan_id
        self.first_name = first_name
        self.last_name = last_name
        self.birth_year = birth_year
        self.birth_month = birth_month
        self.birth_day = birth_day
        self.course = course
        self.stream = stream


    ### GETTER CLASS FUNCTIONS ###
    def spartan_id_getter(self):
        return self.spartan_id
    
    def first_name_getter(self):
        return self.first_name
    
    def last_name_getter(self):
        return self.last_name

    def birth_year_getter(self):
        return self.birth_year
    
    def birth_month_getter(self):
        return self.birth_month

    def birth_day_getter(self):
        return self.birth_day

    def course_getter(self):
        return self.course
    
    def stream_getter(self):
        return self.stream
    

    ###SETTER CLASS FUNCTIONS###
    def spartan_id_setter():
        while True:
            sparta_iden = input("What is the employee ID: ")
            checked = Spartan.ID_validation(sparta_iden)
            if checked == "v":
                return sparta_iden
    

    def first_name_setter():
        while True:
            f_name = input("What is the First Name of the employee: ")
            checked = Spartan.first_last_name_validation(f_name)
            if checked == "v":
                return f_name


    def last_name_setter():
         while True:
            l_name = input("What is the Last Name of the employee: ")
            checked = Spartan.first_last_name_validation(l_name)
            if checked == "v":
                return l_name

       
    def birth_year_setter():
        while True:
            year = input("What is the employees year of birth: ")
            checked = Spartan.year_validation(year)
            if checked == "v":
                return year


    def birth_month_setter():
       while True:
            month = input("What is the employees month of birth: ")
            checked = Spartan.month_validation(month)
            if checked == "v":
                return month


    def birth_day_setter():
        while True:
            day = input("What is the employees day of birth: ")
            checked = Spartan.day_validation(day)
            if checked == "v":
                return day


    def course_setter():
        while True:
            course = input("What is the employee course: ")
            checked = Spartan.stream_course_validation(course)
            if checked == "v":
                return course


    def stream_setter():
        while True:
            stream = input("What is the employee stream: ")
            checked = Spartan.stream_course_validation(stream)
            if checked == "v":
                return stream
        

#### validation functions #####
    def stream_course_validation(text):
        if str(text):
            return "v"
        else:
            print("Input must be a non-empty string")


    def first_last_name_validation(name):
        if len(name.strip()) > 1:
            return "v" 
        else:
            print("Name must be a minimum of 2 Characters")
            return "ERROR"
            

    def day_validation(number):

        try:
            x = int(number)
            if 1 <= x <= 31:
                return "v"
            else:
                print("Must be an integer between 1 and 31")
                return "ERROR"
        except ValueError:
            print("Must be an integer between 1 and 31")
            return "ERROR"


    def year_validation(number): 

        try:
            x = int(number)
            if 1900 <= x <= 2004:
                return "v"
            else:
                print("Must be an integer between 1900 and 2004")
                return "ERROR"
        except ValueError:
            print("Must be an integer between 1900 and 2004")
            return "ERROR"


    def month_validation(number):

        try:
            x = int(number)
            if 1 <= x <= 12:
                return "v"
            else:
                print("Must be an integer between 1 and 12")
                return "ERROR"
        except ValueError:
            print("Must be an integer between 1 and 12")
            return "ERROR"


    def ID_validation(number):
        try:
            int(number)
            return "v"

        except ValueError:
            print("You must enter an integer")
            return "ERROR"
           

if __name__ == "__main__":

    spt_id = Spartan.spartan_id_setter()
    f_name = Spartan.first_name_setter()
    l_name = Spartan.last_name_setter()
    year = Spartan.birth_year_setter()
    month = Spartan.birth_month_setter()
    day = Spartan.birth_day_setter()
    course = Spartan.course_setter()
    stream = Spartan.stream_setter()

    worker = Spartan(spt_id, f_name, l_name, year, month, day, course, stream)

    print(worker.__dict__)
