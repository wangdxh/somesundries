#!/bin/bash

cd /etc/swift
swift-ring-builder account.builder create 17 3 1
swift-ring-builder container.builder create 17 3 1
swift-ring-builder object.builder create 17 3 1


for ((i=0; i<=4; i++))
do
    swift-ring-builder account.builder add r1z1-127.0.0.1:6002/d$i 100
    swift-ring-builder container.builder add r1z1-127.0.0.1:6001/d$i 100
    swift-ring-builder object.builder add r1z1-127.0.0.1:6000/d$i 100
done

swift-ring-builder account.builder rebalance
swift-ring-builder container.builder rebalance
swift-ring-builder object.builder rebalance
