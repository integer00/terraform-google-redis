#!/usr/bin/env bash
###
setup_prepare(){
  echo "Setup timezone..."

}
install_packages() {
  echo "Installing packages"
}

setup_redis(){
  echo "Setting up redis..."
}

start_redis(){
  echo "Starting redis instance"
}


setup_prepare
install_packages
setup_redis
start_redis

echo "done"