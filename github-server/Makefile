install:
	zef install --deps-only .
	pip install -r requirements.txt
	bundle install

start-etcd:
	echo "Recuerda escribir export ETCDCTL_API = 3"
	/usr/local/bin/etcd &

