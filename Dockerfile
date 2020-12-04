FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    #For using chromedriver (behat).
    wget \
    libnss3-dev \
    # For latest chrome.
    libappindicator1 \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatspi2.0-0 \
    libdrm2 \
    libgbm1 \
    libgtk2.0-0 \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    unzip

# Install chrome driver (for behat).
COPY scripts/installchromedriver.sh /tmp/installchromedriver.sh
COPY scripts/installchrome.sh /tmp/installchrome.sh
RUN chmod +x /tmp/installchromedriver.sh
RUN chmod +x /tmp/installchrome.sh
RUN sh -c "/tmp/installchromedriver.sh"
RUN sh -c "/tmp/installchrome.sh"

EXPOSE 9515

STOPSIGNAL SIGTERM

# Note - the --whitelisted-ips= argument looks weird but it fixes this issue:
# https://github.com/RobCherry/docker-chromedriver/issues/15.
CMD ["/usr/local/bin/chromedriver", "--whitelisted-ips"]