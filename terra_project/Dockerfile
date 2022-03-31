## start by pulling the python image
FROM python:3.8-alpine 

ADD app /

COPY requirements.txt requirements.txt 

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

ENTRYPOINT [ "python3" , "/app.py" ]
 

