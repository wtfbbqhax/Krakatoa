docker run --priviledged --rm -ti amd64/krakatoa

sudo apk add lxc lxc-download xz

sudo lxc-create --name ubuntu --config /etc/lxc/default.conf --template /usr/share/lxc/templates/lxc-download -- --dist ubuntu --release jammy --arch amd64


# Create lxcbr0

For Alpine Linux, you can create the `lxcbr0` interface manually using the following steps:

1. First, install the `bridge-utils` package if it is not already installed:

   ```
   apk add bridge-utils
   ```

2. Then create a new bridge named `lxcbr0`:

   ```
   brctl addbr lxcbr0
   ```

3. Set the IP address and netmask for the bridge:

   ```
   ip addr add 10.0.3.1/24 dev lxcbr0
   ```

   Note: Change the IP address and subnet mask according to your requirement.

4. Finally, bring up the bridge:

   ```
   ip link set lxcbr0 up
   ```



Summary:

    ```sh
    apk add bridge-utils
    brctl addbr lxcbr0
    ip addr add 10.0.3.1/24 dev lxcbr0
    ip link set lxcbr0 up
    ```


# Finish setup the bridge

1. First, you need to make sure that IP forwarding is enabled on the host. You can check the current state of IP forwarding by running the following command:

   ```sh
   sysctl net.ipv4.ip_forward
   ```

2. If the output is `net.ipv4.ip_forward = 0`, it means that IP forwarding is disabled. To enable it, run the following command:

   ```sh
   sysctl -w net.ipv4.ip_forward=1
   ```

3. Next, you need to configure NAT (Network Address Translation) on the host. This will allow traffic from your container to reach the internet.

   Assuming your host's interface to the internet is `eth0`, you can configure NAT by running the following commands:

   ```sh
   iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
   iptables -A FORWARD -i lxcbr0 -o eth0 -j ACCEPT
   iptables -A FORWARD -i eth0 -o lxcbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
   ```

These commands do the following:

- The first command enables NAT for traffic going out of `eth0`.
- The second command allows traffic from the container's network namespace (`lxcbr0`) to be forwarded to `eth0`.
- The third command allows traffic from `eth0` that is related to an established connection to be forwarded to `lxcbr0`.

Once these commands are run successfully, your container should be able to communicate with the internet.


# Alternative finish setup

1. Enable IP forwarding on the host:

   `echo 1 > /proc/sys/net/ipv4/ip_forward`

2. Add a Masquerade rule in iptables to allow outbound traffic from the container to the internet:

   `iptables -t nat -A POSTROUTING -s 10.0.3.0/24 -o eth0 -j MASQUERADE`

   This will allow traffic from the IPs in the 10.0.3.0/24 subnet (which includes your LXC container) to be masqueraded with the host's IP address when it goes out to the internet through eth0.

3. Add a default route on the container pointing to the host's IP address on the lxcbr0 interface:

   `ip route add default via 10.0.3.1 dev eth0`

   This will ensure that any outgoing traffic from the container is sent to the host's IP address (10.0.3.1) on the lxcbr0 interface, which is connected to the internet through eth0.


1. Enable IP forwarding on the host:

   `echo 1 > /proc/sys/net/ipv4/ip_forward`

2. Add a Masquerade rule in iptables to allow outbound traffic from the container to the internet:

   `iptables -t nat -A POSTROUTING -s 10.0.3.0/24 -o eth0 -j MASQUERADE`

   This will allow traffic from the IPs in the 10.0.3.0/24 subnet (which includes your LXC container) to be masqueraded with the host's IP address when it goes out to the internet through eth0.

3. Add a default route on the container pointing to the host's IP address on the lxcbr0 interface:

   `ip route add default via 10.0.3.1 dev eth0`

   This will ensure that any outgoing traffic from the container is sent to the host's IP address (10.0.3.1) on the lxcbr0 interface, which is connected to the internet through eth0.


# LXC container configuration

1. Configure DNS from the lxc config.

    ```
    lxc.network.ipv4.dns = <DNS_IP>
    ```

    or you must manually update the `/etc/resolve.conf` inside the container.

