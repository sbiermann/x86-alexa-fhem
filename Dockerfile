FROM debian:jessie 
MAINTAINER Stefan Biermann 

ENV TZ 'Europe/Berlin'

RUN apt-get update && apt-get -y install npm nodejs-legacy curl &&\
    apt-get clean\
     && apt-get -yq autoremove\
     && rm -rf /var/lib/apt/lists/*
RUN npm cache clean -f && npm install -g n &&\
    n stable
ADD alexa-fhem-0.3.0.tgz /
RUN mv package alexa-fhem && cd alexa-fhem &&\
	npm install && mkdir ~/.alexa && mkdir /config &&\
    cp config-sample.json /config/config.json && \
    ln -s /config/config.json ~/.alexa/config.json && \
    ln -s /config/key.pem /alexa-fhem/key.pem &&\ 
    ln -s /config/cert.pem /alexa-fhem/cert.pem

COPY start.sh /
VOLUME /config
EXPOSE 3000
CMD ["/start.sh"]
