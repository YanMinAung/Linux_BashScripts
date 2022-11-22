#!/bin/bash
echo -n "Enter Listen Port: "
read port

echo "Select Algorithm: "
ha_algo=("roundrobin" "source" "leastconn" "rdp-cookie")
select algo in "${ha_algo[@]}"; do
cat > tmp_conf <<EOF
frontend http_front
    bind *:${port}
    stats uri /haproxy?stats
    default_backend http_back

backend http_back
    balance ${algo}
EOF
break
done

PS3="Add backend servers: "

while true; do
  echo -n "Add backend? Yes/No: "
  read opt
  case $opt in
    [Yy]es|y)
      echo -n "Enter Server Name: "
      read server_name
      echo -n "Enter Server IP: "
      read server_ip
      echo -n "Enter Server Port: "
      read server_port
      echo "    server $server_name $server_ip:$server_port check" >> tmp_conf
      ;;
    [Nn]o|n)
      exit 0
      ;;
  esac
done
