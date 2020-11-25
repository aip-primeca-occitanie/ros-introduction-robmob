ARG UBUNTU_VERSION=18.04
FROM osrf/ros:melodic-desktop-full

ARG UBUNTU=bionic
ARG ROS_DISTRO=melodic

# ROS & robotpkg packages repository
ADD repos.key /
RUN apt-get update -qqy && apt-get install -qqy gnupg2 && rm -rf /var/lib/apt/lists \
 && echo "deb [arch=amd64] http://robotpkg.openrobots.org/wip/packages/debian/pub ${UBUNTU} robotpkg" > /etc/apt/sources.list.d/robotpkg.list \
 && echo "deb [arch=amd64] http://robotpkg.openrobots.org/packages/debian/pub ${UBUNTU} robotpkg" >> /etc/apt/sources.list.d/robotpkg.list \
 && apt-key add /repos.key

# environment helpers
ENV ROS_PREFIX=/opt/ros/${ROS_DISTRO} ROBOTPKG_BASE=/opt/openrobots
# required environment variables
ENV PYTHONPATH=${ROBOTPKG_BASE}/lib/python2.7/site-packages:${ROS_PREFIX}/lib/python2.7/dist-packages \
    CMAKE_PREFIX_PATH=${ROBOTPKG_BASE}:${ROS_PREFIX} \
    LD_LIBRARY_PATH=${ROBOTPKG_BASE}/lib/dynamic-graph-plugins \
    QT_X11_NO_MITSHM=1

RUN apt-get update -qqy \
 && DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
    emacs \
    git \
    imagemagick \
    mesa-utils \
    net-tools \
    novnc \
    onboard \
    robotpkg-py27-tiago-tutorials \
    tigervnc-standalone-server \
    tigervnc-xorg-extension \
    terminator \
    ros-melodic-dwa-local-planner \    
    ros-melodic-gmapping \
    ros-melodic-map-server \
    ros-melodic-moveit-planners-ompl \
    ros-melodic-moveit-ros-planning-interface \
    ros-melodic-moveit-simple-controller-manager \
    ros-melodic-opencv-apps \
    ros-melodic-turtlebot3-bringup \    
    ros-melodic-turtlebot3-description \
    ros-melodic-turtlebot3-slam \
    ros-melodic-turtlebot3-simulations \
    ros-melodic-turtlebot3-navigation \
    ros-melodic-twist-mux \
    x11-apps \
    xfce4 \
    wget \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir ~/.vnc \
 && echo "#!/bin/sh\nstartxfce4" > ~/.vnc/xstartup \
 && chmod +x ~/.vnc/xstartup

RUN mkdir /root/bin
ADD setup-robotpkg.sh /root/bin/
ADD entrypoint.sh /
CMD /entrypoint.sh
