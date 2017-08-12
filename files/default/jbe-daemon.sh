#!/bin/sh

JAVA_HOME=/opt/IBM/InstallationManager/eclipse/jre_7.0.9040.20160504_1613/jre
export JAVA_HOME

/usr/lib/jbe/buildsystem/buildengine/eclipse/jbe.sh "$@" >> /var/log/jbe.log &