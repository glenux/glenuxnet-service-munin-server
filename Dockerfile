FROM debian:buster-slim

MAINTAINER Glenn Rolland <glenux@glenux.net>
# Based on the original work of Leo Unbekandt <leo@scalingo.com>

RUN adduser --system \
            --home /var/lib/munin \
            --shell /bin/false \
            --uid 1103 \
            --group munin

ENV RUNLEVEL=1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq \
 && apt-get install -y -qq cron munin munin-node nginx apache2-utils \
        wget s-nail patch rsyslog

RUN rm /etc/nginx/sites-enabled/default \
 && mkdir -p /var/cache/munin/www \
 && chown munin:munin /var/cache/munin/www \
 && mkdir -p /var/run/munin \
 && chown -R munin:munin /var/run/munin

VOLUME /var/lib/munin
VOLUME /var/log/munin

ADD ./munin.conf /etc/munin/munin.conf
ADD ./nginx-munin /etc/nginx/sites-enabled/munin
ADD ./start-munin.sh /munin
ADD ./munin-graph-logging.patch /usr/share/munin
ADD ./munin-update-logging.patch /usr/share/munin

RUN cd /usr/share/munin \
 && patch munin-graph < munin-graph-logging.patch \
 && patch munin-update < munin-update-logging.patch

EXPOSE 8080
CMD ["bash", "/munin"]

