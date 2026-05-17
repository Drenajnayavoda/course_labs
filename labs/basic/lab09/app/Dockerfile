FROM python:3.9

ENV API_TOKEN=lab09-fake-token-not-a-real-secret-placeholder
ENV DB_PASSWORD=P@ssw0rd_super_secret_123

WORKDIR /app

ADD requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ADD . /app

EXPOSE 8080

CMD ["python", "app.py"]
