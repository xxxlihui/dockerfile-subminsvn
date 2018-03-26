FROM debian:jessie
MAINTAINER lhn <550124023@qq.com>

ENV SUBMIN_VERSION 2.2.2-1

VOLUME /var/lib/svn
VOLUME /var/lib/submin
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh \
    apt-get update \
    && apt-get install -y --no-install-recommends \
       python \
       subversion \
       python-subversion \
       apache2 \
       libapache2-svn \
       sendmail \
       curl \
       sqlite3 \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
    && curl --insecure -fSL "http://supermind.nl/submin/current/submin-${SUBMIN_VERSION}.tar.gz" -o submin.tar.gz \
    && tar -xf submin.tar.gz -C /opt/ \
    && rm submin.tar.gz \
    && cd /opt/submin-${SUBMIN_VERSION} \
    && python setup.py install \
    && cd / \
    && rm -rf /opt/submin-${SUBMIN_VERSION}

COPY ./docker-entrypoint.sh /

RUN usermod -u 1000 www-data

EXPOSE 80
CMD "/docker-entrypoint.sh"
#CMD ["submin"]
