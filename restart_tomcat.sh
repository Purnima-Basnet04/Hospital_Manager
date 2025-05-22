#!/bin/bash

# Find Tomcat process
TOMCAT_PIDS=$(ps aux | grep tomcat | grep -v grep | awk '{print $2}')

if [ -n "$TOMCAT_PIDS" ]; then
    echo "Stopping Tomcat (PIDs: $TOMCAT_PIDS)..."
    for PID in $TOMCAT_PIDS; do
        echo "Killing PID: $PID"
        kill $PID 2>/dev/null || echo "Could not kill PID: $PID"
    done
    sleep 5

    # Check if processes are still running
    for PID in $TOMCAT_PIDS; do
        if ps -p $PID > /dev/null 2>&1; then
            echo "Tomcat process $PID did not stop gracefully, forcing kill..."
            kill -9 $PID 2>/dev/null || echo "Could not force kill PID: $PID"
        fi
    done

    echo "Tomcat stopped."
else
    echo "Tomcat is not running."
fi

# Start Tomcat
echo "Starting Tomcat..."
# This command might need to be adjusted based on your Tomcat installation
if [ -f "$HOME/tomcat/apache-tomcat-11.0.0-M22/bin/startup.sh" ]; then
    $HOME/tomcat/apache-tomcat-11.0.0-M22/bin/startup.sh
    echo "Tomcat started."
else
    echo "Could not find Tomcat startup script."
fi
