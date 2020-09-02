FROM python:3.8.5-alpine

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir /app
WORKDIR /app

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev netcat-openbsd

RUN pip install --upgrade pip
COPY ./app/requirements.txt .
RUN pip install -r requirements.txt

COPY ./entrypoint.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY ./app .

ENTRYPOINT ["entrypoint.sh"]