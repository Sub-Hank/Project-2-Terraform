FROM python:3.11-slim
WORKDIR /app
COPY app.py /app/
RUN python -m pip install --no-cache-dir flask psycopg2-binary
EXPOSE 5000
CMD ["python", "app.py"]
