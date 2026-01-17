FROM python:3.13-slim

WORKDIR /action

RUN pip install metablock[cli]==1.1
