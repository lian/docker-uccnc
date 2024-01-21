FROM accetto/ubuntu-vnc-xfce-opengl-g3:latest

USER 0

RUN \
    dpkg --add-architecture i386 \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends winehq-stable cabextract

RUN wget -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x /usr/bin/winetricks

ADD ./UCCNC.sh /home/headless/Desktop/

USER "${HEADLESS_USER_ID}":"${HEADLESS_USER_GROUP_ID}"

#CMD [ "xfc4-terminal", "--command=/home/headless/Desktop/UCCNC.sh" ]
