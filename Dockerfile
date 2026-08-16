FROM python:3.14-slim

WORKDIR /action

RUN pip install "metablock[cli]==2.0.0"
