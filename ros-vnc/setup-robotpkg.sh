#!/bin/bash

# echo $#

rpkg_priority=0
ros_reset=0
detected_robotpkg=0

usage()
{
    echo "usage: $0 -p /opt/openrobots [-R] [-r] [-h]"
    echo "   -p: [required] path to robotpkg install directory"
    echo "   -R: [optional] source ROS release setup.bash file"
    echo "   -r: [optional] robotpkg has the highest priority"
}

verboseinfo()
{
    echo "ROS reset: $ros_reset"
    echo "Robotpkg priority: $rpkg_priority"
    echo "ROS_PACKAGE_PATH: $ROS_PACKAGE_PATH"
    echo "rpkg_path: $rpkg_path"
}

setting_robotpkg_base()
{
    detected_robotpkg_ok=1
    # Test if candidate_value/var/db/robotpkg exists
    if [ ! -d $1/var/db/robotpkg ]; then
        detected_robotpkg_ok=0
    fi

    if [ $detected_robotpkg_ok -eq 1 ]; then
        export ROBOTPKG_BASE=$1
    fi
}

# Dealing with parameters
while [ "$1" != "" ]; do
    case $1 in
        -p | --rpkg-path )      shift
                                rpkg_path=$1
                                ;;
        -R | --ros-reset )      ros_reset=1
                                ;;
        -r | --rpkg-priority )  rpkg_priority=1
                                ;;
        -v | --verbose )        verboseinfo
                                exit
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# Detect Ubuntu release
if [ -f /etc/lsb-release ]; then
    (. /etc/lsb-release;
     echo "#!/bin/bash" > /tmp/local.bash
     echo "export DISTRIB_CODENAME="$DISTRIB_CODENAME >> /tmp/local.bash;
     echo "export DISTRIB_RELEASE="$DISTRIB_RELEASE >> /tmp/local.bash;
     echo "export DISTRIB_DESCRIPTION=\""$DISTRIB_DESCRIPTION\" >> /tmp/local.bash;)
    . /tmp/local.bash
fi

if [ $ros_reset -eq 1 ]; then
  echo "Reset ROS"
  # If the release is 12.04 LTS
  if [ $DISTRIB_RELEASE == "12.04" ]; then
    # ROS is set to Hydro
    . /opt/ros/hydro/setup.bash
  fi

  # If the release is 14.04 LTS
  if [ $DISTRIB_RELEASE == "14.04" ]; then
    # ROS is set to Indigo
    . /opt/ros/indigo/setup.bash
  fi

  # If the release is 16.04 LTS
  if [ $DISTRIB_RELEASE == "16.04" ]; then

    # Specific Machine architecture
    export MACHINE_ARCH=x86_64

    # ROS is set to Indigo
    . /opt/ros/kinetic/setup.bash
  fi
fi

if [ -f /usr/share/gazebo-9/setup.sh ]; then
    . /usr/share/gazebo-9/setup.sh
fi

setting_robotpkg_base ${rpkg_path}

if [ $rpkg_priority -eq 1 ];
then
  export PATH=$rpkg_path/sbin:$rpkg_path/bin:$PATH
  export LD_LIBRARY_PATH=$rpkg_path/lib:$rpkg_path/lib/dynamic-graph-plugins:$rpkg_path/lib64:$LD_LIBRARY_PATH
  export PYTHONPATH=$rpkg_path/lib/python2.7/site-packages:$PYTHONPATH
  export PKG_CONFIG_PATH=$rpkg_path/lib/pkgconfig/:$PKG_CONFIG_PATH
  export ROS_PACKAGE_PATH=$rpkg_path/share:$ROS_PACKAGE_PATH
  export CMAKE_PREFIX_PATH=$rpkg_path:$CMAKE_PREFIX_PATH
  export GAZEBO_MODEL_PATH=$rpkg_path/share/pal_gazebo_worlds/models:$GAZEBO_MODEL_PATH
  export GAZEBO_PLUGIN_PATH=$GAZEBO_PLUGIN_PATH:/opt/openrobots/lib
  export GAZEBO_RESOURCE_PATH=$rpkg_path/share/pal_gazebo_worlds:/usr/share/gazebo-9:$GAZEBO_RESOURCE_PATH
else
  export PATH=$PATH:$rpkg_path/sbin:$rpkg_path/bin
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$rpkg_path/lib:$rpkg_path/lib//dynamic-graph-plugins:$rpkg_path/lib64
  export PYTHONPATH=$PYTHONPATH:$rpkg_path/lib/python2.7/site-packages
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$rpkg_path/lib/pkgconfig/
  export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$rpkg_path/share
  export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$rpkg_path
  export GAZEBO_MODEL_PATH=$rpkg_path/share/pal_gazebo_worlds/models:$GAZEBO_MODEL_PATH
  export GAZEBO_PLUGIN_PATH=$GAZEBO_PLUGIN_PATH:$rpkg_path/lib
  export GAZEBO_RESOURCE_PATH=$ROBOTBPKG_BASE/share/pal_gazebo_worlds:/usr/share/gazebo-9:$GAZEBO_RESOURCE_PATH
fi
