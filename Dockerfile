FROM node:20-alpine3.16
RUN apk update && apk upgrade
RUN apk add --no-cache \
  openssh \
  rsync \
  tar
RUN npm install elasticdump -g


# copy crontabs for root user
COPY config/cronjobs /etc/crontabs/root

COPY config/id_rsa /root/.ssh/
RUN chmod 600 ~/.ssh/id_rsa

COPY config/elasticsearch_backup.sh /root/
RUN chmod u+r+x /root/elasticsearch_backup.sh



# start crond with log level 8 in foreground, output to stderr
CMD ["crond", "-f", "-d", "8"]