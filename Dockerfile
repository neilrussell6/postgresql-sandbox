FROM python:3
ENV PYTHONUNBUFFERED 1

# custom commands
RUN apt-get update
RUN apt-get install nano

# project directory
RUN mkdir /code
WORKDIR /code

# copy requirements
RUN mkdir /_requirements
ADD _requirements/test.txt /code/_requirements/

# install requirements
RUN pip install -r _requirements/test.txt

# project files
ADD . /code/
