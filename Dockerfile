FROM ubuntu:20.04
# Install various things
RUN apt-get update && apt-get install --no-install-recommends -y  \
    # For using chromedriver (behat).
    curl \
    wget \
    libnss3 \
    # For latest chrome.
    ca-certificates \
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
    libxshmfence1 \
    xdg-utils \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "ca_directory=/etc/ssl/certs" >> /etc/wgetrc

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
