#!/bin/bash

THISDIR=$(readlink -f $(dirname $BASH_SOURCE))

pushd packages/caliper-samples/network/fabric-v1.4.1-minbft/config
bash generate.sh
popd

if [ "$RUNNAME" == reference ] ; then
	docker rm -f $(docker ps -qa)
	echo "#### Solo (LevelDB)"
	caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1/2org1peergoleveldb/fabric-ccp-node.yaml

	docker rm -f $(docker ps -qa)
	echo "#### Solo (LevelDB, TLS enabled)"
	caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1/2org1peergoleveldb/fabric-ccp-node-tls.yaml

	docker rm -f $(docker ps -qa)
	echo "#### Solo (LevelDB, Mutual TLS enabled)"
	caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1/2org1peergoleveldb/fabric-ccp-node-mutual-tls.yaml

	echo "#### Solo (CouchDB)"
	caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1/2org1peercouchdb/fabric-ccp-node.yaml

	docker rm -f $(docker ps -qa)
	echo "#### Solo (CouchDB, TLS enabled)"
	caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1/2org1peercouchdb/fabric-ccp-node-tls.yaml

	docker rm -f $(docker ps -qa)
	echo "#### Solo (CouchDB, Mutual TLS enabled)"
	caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1/2org1peercouchdb/fabric-ccp-node-mutual-tls.yaml

	docker rm -f $(docker ps -qa)
	echo "#### Kafka"
	caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4/kafka/fabric-ccp-node.yaml

	docker rm -f $(docker ps -qa)
	echo "#### Kafka (TLS enabled)"
	caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4/kafka/fabric-ccp-node-tls.yaml

	docker rm -f $(docker ps -qa)
	echo "#### Raft (TLS enabled)"
	caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1/raft/fabric-ccp-node-tls.yaml
elif [ "$RUNNAME" == minbft ] ; then
	if [ "$SGX_MODE" == HW ] ; then
		docker rm -f $(docker ps -qa)
		caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1-minbft/2org1peercouchdb/fabric-ccp-node-hw.yaml
		docker rm -f $(docker ps -qa)
		caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1-minbft/2org1peercouchdb/fabric-ccp-node-tls-hw.yaml
	else
		docker rm -f $(docker ps -qa)
		caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1-minbft/2org1peercouchdb/fabric-ccp-node-sim.yaml
		docker rm -f $(docker ps -qa)
		caliper benchmark run -w packages/caliper-samples -c benchmark/simple/config.yaml -n network/fabric-v1.4.1-minbft/2org1peercouchdb/fabric-ccp-node-tls-sim.yaml
	fi
fi
