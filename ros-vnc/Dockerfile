FROM osrf/ros:melodic-desktop-full

RUN apt-get update -qqy \
 && DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
    emacs \
    git \
    mesa-utils \
    net-tools \
    novnc \
    onboard \
    tigervnc-standalone-server \
    tigervnc-xorg-extension \
    terminator \
    turtlebot3_description \    
    turtlebot3_simulations \
    x11-apps \
    xfce4 \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir ~/.vnc \
 && echo "#!/bin/sh\nstartxfce4" > ~/.vnc/xstartup \
 && chmod +x ~/.vnc/xstartup

ADD entrypoint.sh /
CMD /entrypoint.sh


