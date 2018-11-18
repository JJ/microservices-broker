#!/bin/bash

export ETCDCTL_API=3
etcdctl put hook_port 31415
etcdctl put queue_name hook
etcdctl put exchange_name log
etcdctl put store_port 2314
