deploy:
	kind create cluster --config cluster.yaml

destroy:
	kind delete cluster