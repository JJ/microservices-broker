install:
	zef install --deps-only .
	pip install -r requirements.txt
	bundle install

start-etcd:
	echo "Recuerda escribir export ETCDCTL_API = 3"
	/usr/local/bin/etcd

set-config:
	export ETCDCTL_API=3; etcdctl put hook_port 31415; etcdctl put queue_name hook; etcdctl put store_port 2314
