FROM ubuntu:bionic

ENV HOME /remix

ENV USER_ID 1000
ENV GROUP_ID 1000

RUN groupadd -g ${GROUP_ID} remix \
  && useradd -u ${USER_ID} -g remix -s /bin/bash -m -d /remix remix \
  && set -x \
  && apt-get update -y \
  && apt-get install -y curl git python build-essential wget \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG ideversion=0.10.0
ENV REMIX_IDE_VERSION=$ideversion

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER remix
WORKDIR /remix

ENV NVM_DIR $HOME/.nvm
ENV NODE_VERSION 10.20.0
RUN mkdir -p $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN /bin/bash -l -c "\
  source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm install-latest-npm \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && npm config set python /usr/bin/python --global \
  && npm config set python /usr/bin/python \
  && npm install typescript@^3.7.4 -g"

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN mkdir -p /remix/remix-ide && mkdir -p /remix/app

RUN curl -sL https://github.com/ethereum/remix-ide/archive/v$REMIX_IDE_VERSION.tar.gz | tar xz --strip=1 -C /remix/remix-ide

WORKDIR /remix/remix-ide

RUN npm install

VOLUME ["/remix/app"]

EXPOSE 8080
EXPOSE 65520

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]