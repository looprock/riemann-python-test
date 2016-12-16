FROM ubuntu
MAINTAINER Doug Land <dland@ojolabs.com>

# Install dependencies
RUN apt-get update
RUN apt-get install -y python-setuptools curl rubygems supervisor
RUN easy_install bernhard
RUN gem install --no-rdoc --no-ri riemann-client riemann-tools
RUN sed -i "s/logfile/nodaemon=true\nlogfile/g" /etc/supervisor/supervisord.conf
RUN printf "[program:riemann-health]\ncommand=/usr/local/bin/riemann-health -h %%(ENV_RIEMANN_PORT_5555_TCP_ADDR)s\n" > /etc/supervisor/conf.d/riemann-health.conf
RUN printf "[program:fakerando]\ncommand=/usr/bin/python /tmp/fakerando\n" > /etc/supervisor/conf.d/fakerando.conf

ADD fakerando /tmp/fakerando

# Set the hostname in /etc/hosts so that Riemann doesn't die due to unknownHostException
CMD echo 127.0.0.1 $(hostname) > /etc/hosts; /usr/bin/supervisord
