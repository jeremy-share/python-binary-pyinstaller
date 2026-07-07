FROM python:3.11-alpine3.18

RUN     apk add --no-cache --virtual .build-deps gcc musl-dev make \
    &&  pip3 install --upgrade pip \
    &&  mkdir -p /opt/project

WORKDIR /opt/project

COPY project/requirements.in ./project/requirements.in
COPY Makefile ./
RUN pip3 install -r project/requirements.in
COPY project ./project
COPY build_alpine ./build_alpine

CMD ["make", "build-alpine"]
