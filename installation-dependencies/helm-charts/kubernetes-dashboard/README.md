Kubernetes Dashboard customized to work on AWS EKS via NodePort Service

The version used: https://github.com/kubernetes/dashboard/releases/tag/v2.0.0-rc5

https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc5/aio/deploy/recommended.yaml

To obtain the access token, run: `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')`