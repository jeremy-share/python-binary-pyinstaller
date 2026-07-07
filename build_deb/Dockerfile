FROM python:3.11-bookworm

RUN     pip3 install --upgrade pip \
    &&  mkdir -p /opt/project

WORKDIR /opt/project

COPY project/requirements.in ./project/requirements.in
COPY Makefile ./
RUN pip3 install -r project/requirements.in
COPY project ./project
COPY build_deb ./build_deb

CMD ["make", "build-deb"]
