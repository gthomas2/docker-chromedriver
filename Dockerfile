FROM ubuntu:18.04
#install various things
RUN apt-get update && apt-get install --no-install-recommends -y  \
    #For using chromedriver (behat).
    curl=7.64.0-4+deb10u2 \
    wget=1.20.1-1.1 \
    libnss3-dev=2:3.42.1-1+deb10u3 \
    # For latest chrome.
    libappindicator1=0.4.92-7 \
    fonts-liberation=1:1.07.4-9 \
    libappindicator3-1=0.4.92-7 \
    libasound2=1.1.8-1 \
    libatk-bridge2.0-0=2.30.0-5 \
    libatspi2.0-0=2.30.0-7 \
    libdrm2=2.4.97-1 \
    libgbm1=18.3.6-2+deb10u1 \
    libgtk2.0-0=2.24.32-3 \
    libx11-xcb1=2:1.6.7-1+deb10u2 \
    libxcb-dri3-0=1.13.1-2 \
    libxss1=1:1.2.3-1 \
    libxtst6=2:1.2.3-1 \
    libxshmfence1=1.3-1 \
    xdg-utils=1.1.3-1+deb10u1 \
    unzip=6.0-23+deb10u2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install chrome driver (for behat).
# https://gist.github.com/mikesmullin/2636776#gistcomment-1658459
RUN wget --progress=dot:giga -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
dpkg -i /tmp/google-chrome.deb && \
mkdir -p /tmp/chromedriver/ && \
wget --progress=dot:giga -O /tmp/chromedriver/LATEST_RELEASE http://chromedriver.storage.googleapis.com/LATEST_RELEASE && \
latest=$(cat /tmp/chromedriver/LATEST_RELEASE) && \
wget --progress=dot:giga -O /tmp/chromedriver/chromedriver.zip 'http://chromedriver.storage.googleapis.com/'"$latest"'/chromedriver_linux64.zip' && \
unzip /tmp/chromedriver/chromedriver.zip chromedriver -d /usr/local/bin/ && \
chmod 755 /usr/local/bin/chromedriver

EXPOSE 9515

STOPSIGNAL SIGTERM

# Note - the --whitelisted-ips= argument looks weird but it fixes this issue:
# https://github.com/RobCherry/docker-chromedriver/issues/15.
CMD ["/usr/local/bin/chromedriver", "--whitelisted-ips"]