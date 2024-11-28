FROM python:3
RUN pip3 install django

COPY . .
RUN python3 manage.py makemigrations
RUN python3 manage.py migrate

CMD ["python3","manage.py","runserver","0.0.0.0:8000"]
