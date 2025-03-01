#!/bin/sh

# Check if httpd exists (debugging step)
if ! command -v httpd >/dev/null; then
    echo "Error: httpd not found!"
    exit 1
fi

# Check if ftpd exists
if ! command -v vsftpd >/dev/null; then
    echo "Error: vsftpd not found!"
    exit 1
fi

# Start HTTP server
httpd -D FOREGROUND >> /var/log/httpd.log 2>&1 &
HTTPD_PID=$!

# Start FTP server
vsftpd /etc/vsftpd/vsftpd.conf >> /var/log/vsftpd.log 2>&1 &
VSFTPD_PID=$!

# Handle shutdown signals
trap "kill $HTTPD_PID $VSFTPD_PID; exit" SIGTERM SIGINT

# Keep the container running
wait $HTTPD_PID $VSFTPD_PID
