FROM python:3.6-alpine
MAINTAINER chao.wang "chao.wang@gwc.net"
# package源大陆加速
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories
#ENV
ENV APP_DIR /opt/app

# update source
RUN apk update && \
	apk add supervisor && \
	pip3 install -i https://pypi.douban.com/simple flask gunicorn && \
	mkdir -p ${APP_DIR}/web && \
	mkdir -p ${APP_DIR}/conf && \
	mkdir -p ${APP_DIR}/logs && \
	rm -rf /var/cache/apk/* && \
	echo "files = ${APP_DIR}/conf/*.ini" >> /etc/supervisord.conf

#config files
COPY ./app ${APP_DIR}

#volume map
VOLUME ["${APP_DIR}"]

#port
EXPOSE 5000

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
