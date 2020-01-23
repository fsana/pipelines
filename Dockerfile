# base image
FROM alpine:3.7

# install python 3 and pip
RUN apk add --update python3

# install required python modules 
COPY requirements.txt /usr/src/app/
RUN pip3 install --no-cache-dir -r /usr/src/app/requirements.txt

# copy required files to run the app
COPY app.py /usr/src/app
COPY templates/index.html /usr/src/app/templates/

# export flask port (5000)
EXPOSE 5000

# run the application
CMD ["python3", "/usr/src/app/app.py"]
