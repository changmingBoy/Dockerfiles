FROM changmingjiang/debian:latest

LABEL maintainer="changming.jiang<changming.jiang@qq.com>"

ENV  CONSUL_DATA_DIR=/opt/consul/data \
     CONSUL_CONFIG_DIR=/opt/consul/config

ARG CONSUL_VERSION=${CONSUL_VERSION}
ARG CONSUL_GPG_KEYS=91A6E7F85D05C65630BEF18951852D87348FFC4C

# https://github.com/hashicorp/docker-consul/blob/master/0.X/Dockerfile

RUN set -ex; \
	\
	apt-get update; \
	apt-get install -y unzip iproute2 dumb-init jq moreutils aria2 --no-install-recommends; \
	\
	aria2c -l -c -x16 "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"; \
	aria2c -l -c -x16 "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS"; \
	aria2c -l -c -x16 "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig"; \
	\
	export GNUPGHOME="$(mktemp -d)"; \
	gpg  --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $CONSUL_GPG_KEYS; \
	gpg --export $CONSUL_GPG_KEYS > /etc/apt/trusted.gpg.d/consul.gpg; \
	gpg --batch --verify consul_${CONSUL_VERSION}_SHA256SUMS.sig consul_${CONSUL_VERSION}_SHA256SUMS; \
	grep consul_${CONSUL_VERSION}_linux_amd64.zip consul_${CONSUL_VERSION}_SHA256SUMS | sha256sum -c; \
	\
	unzip -d /bin consul_${CONSUL_VERSION}_linux_amd64.zip; \
	apt-get remove -y aria2; \
	rm -rf "$GNUPGHOME" consul_* /var/lib/apt/lists/*; \
	\
	mkdir -p ${CONSUL_DATA_DIR} ${CONSUL_CONFIG_DIR}; \
	echo '{"data_dir":"'${CONSUL_DATA_DIR}'"}' > ${CONSUL_CONFIG_DIR}/config.json; \
	\
	groupadd -r consul && useradd -r -g consul consul; \
	consul version

WORKDIR /opt/consul

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]