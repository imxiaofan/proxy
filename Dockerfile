FROM ubuntu

# Install dependencies
RUN apt-get update && apt-get install -y \
    openconnect \
    iproute2 \
    tinyproxy \
    && rm -rf /var/lib/apt/lists/*

# Create TUN device
RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    chmod 0666 /dev/net/tun && \
    mknod /dev/vhost-net c 10 238 && \
    chmod 0666 /dev/vhost-net

# Allow unprivileged user namespace access to TUN device
RUN echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.conf

RUN echo "Port 8888" > /etc/tinyproxy/tinyproxy.conf && \
    echo "User nobody" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "LogLevel Info" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "MaxClients 100" >> /etc/tinyproxy/tinyproxy.conf

RUN echo "service tinyproxy start" > /docker-entrypoint.sh && \
    echo "echo \"\$VPN_PASSWORD\" | openconnect --protocol=anyconnect \$VPN_SERVER --user=\$VPN_USER --passwd-on-stdin 2>&1 | tee /var/log/vpn.log" >> /docker-entrypoint.sh && \
    echo "tail -100f /var/log/vpn.log" >> /docker-entrypoint.sh &&\

# Start command
CMD ["/bin/bash", "/docker-entrypoint.sh"]

