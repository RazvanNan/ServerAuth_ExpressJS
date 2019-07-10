#!/bin/bash

# This file runs in parallel: the DB server, Node server and the cURL client

#Explanation for the below:
# > /dev/null: redirects the output of command(stdout) to /dev/null
# 2>&1: redirects stderr to stdout, so errors (if any) also goes to /dev/null
# & send a process to background

# DB Server
db () {
  cd ./db
  npm run json:server > /dev/null 2>&1 &
  P1=$!
}

#Node Server
server () {
  cd ../server
  npm run dev:server > /dev/null 2>&1 &
  P2=$!
}

#Client cURL
client () {
  clear
  echo
  echo "Pls press Enter for starting client command (cURL)."
  read
  curl http://localhost:3000/login -c cookie-file.txt -H 'Content-Type: application/json' -d '{"email":"test@test.com", "password":"password"}' -L
}


db
echo "DB started......"
pwd

server
echo "Server started...."
pwd

sleep 3 # waits 3 secs for Node server to start  
client

echo
echo "Waiting now.... pls press ^C for stopping DB and Node servers."
wait $P1 $P2
