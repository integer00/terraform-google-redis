#!/usr/bin/env bash
###
export REDIS_PORT=${redis_port}

set -e

exit_trap () {
  local lc="$BASH_COMMAND" rc=$?
  echo "Last command ($lc) is exited with ($rc) code."
}

trap exit_trap EXIT

install_packages() {
  echo "Installing packages"
  echo "-------------------"

  printf "Get stable redis from redis.io"
  cd /tmp
  curl -L -s 'http://download.redis.io/redis-stable.tar.gz'| tar -xz --
  echo "...OK"

  cd ./redis-stable

  printf "Get gcc and stuff to compile redis"
  yum group install "Development Tools" -q -y
  if make -s; then
    cd ./src
    cp redis-benchmark redis-check-aof redis-check-rdb redis-cli redis-sentinel redis-server /usr/bin
    echo "...OK"
  else exit 1
 fi
}

setup_redis(){
  echo "Setting up redis"
  echo "----------------"

  printf "add redis user"
  adduser redis -d /var/lib/redis -c "a redis user" -s /sbin/nologin
  echo "...OK"

  printf "make sure redis dir is created"
  mkdir -p /var/lib/redis
  echo "...OK"

  echo "template redis.conf"
  cat <<EOF > /etc/redis.conf

################################## INCLUDES ###################################

################################## MODULES #####################################

################################## NETWORK #####################################

bind 127.0.0.1

protected-mode yes

port $REDIS_PORT

tcp-backlog 511

timeout 0

tcp-keepalive 300

################################# GENERAL #####################################

daemonize yes

supervised systemd

pidfile /var/run/redis_$REDIS_PORT.pid

loglevel notice

logfile ""

databases 16

always-show-logo yes

################################ SNAPSHOTTING  ################################

save 900 1
save 300 10
save 60 10000

stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb

dir /var/lib/redis/

################################# REPLICATION #################################

replica-serve-stale-data yes
replica-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
replica-priority 100

################################## SECURITY ###################################

################################### CLIENTS ####################################

############################## MEMORY MANAGEMENT ################################

############################# LAZY FREEING ####################################

lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no

############################## APPEND ONLY MODE ###############################

appendonly no
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble yes

################################ LUA SCRIPTING  ###############################

lua-time-limit 5000

################################ REDIS CLUSTER  ###############################

########################## CLUSTER DOCKER/NAT support  ########################

################################## SLOW LOG ###################################

slowlog-log-slower-than 10000
slowlog-max-len 128

################################ LATENCY MONITOR ##############################

latency-monitor-threshold 0

############################# EVENT NOTIFICATION ##############################

notify-keyspace-events ""

############################### ADVANCED CONFIG ###############################

hash-max-ziplist-entries 512
hash-max-ziplist-value 64

list-max-ziplist-size -2

list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64

hll-sparse-max-bytes 3000

stream-node-max-bytes 4096
stream-node-max-entries 100

activerehashing yes

client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60

hz 10
dynamic-hz yes

aof-rewrite-incremental-fsync yes
rdb-save-incremental-fsync yes

########################### ACTIVE DEFRAGMENTATION #######################
EOF

echo "generate systemd unit"
cat <<EOF > /usr/lib/systemd/system/redis.service
[Unit]
Description=Redis persistent key-value database
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/redis-server /etc/redis.conf --supervised systemd
ExecStop=/usr/bin/redis-cli shutdown
Type=notify
User=redis
Group=redis
RuntimeDirectory=redis
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
EOF
}

start_redis(){
  echo "Starting redis"
  echo "--------------"

  printf "Enable redis in systemd"
  systemctl -q enable redis
  echo "...OK"

  printf "starting redis"
  systemctl -q start redis
  echo "...OK"
}

cleanup(){
  echo "removing stuff"
  echo "--------------"
  yum -q -y group remove "Development Tools"
  rm -rf /tmp/redis-stable
}


install_packages
setup_redis
start_redis
cleanup

echo "done"

exit 0