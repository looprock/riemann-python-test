FROM ubuntu
MAINTAINER Doug Land <dland@ojolabs.com>

# Install dependencies
RUN apt-get update
RUN apt-get install -y python-setuptools curl
RUN easy_install bernhard

ADD fakerando /tmp/fakerando


# Set the hostname in /etc/hosts so that Riemann doesn't die due to unknownHostException
CMD /usr/bin/python /tmp/fakerando
