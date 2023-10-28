#!/usr/bin/env bash

if [[ ! -z $1 ]]; then
  namespace=$1
else
  namespace="lingua-finder"
fi

kubectl create namespace ${namespace}
kubectl delete secret/webapp --namespace=${namespace}
kubectl delete secret/mongodb --namespace=${namespace}
kubectl delete secret/postgresql --namespace=${namespace}
kubectl delete secret/redis --namespace=${namespace}

mongodb_password=$(pwgen --no-capitalize -s -1 20)
postgresql_password=$(pwgen --no-capitalize -s -1 20)
redis_password=$(pwgen --no-capitalize -s -1 20)

kubectl create secret generic webapp \
  --from-literal=SECRET_KEY_BASE=$(pwgen --no-capitalize -s -1 80) \
  --from-literal=DATABASE_URL=postgres://lingua_finder:$postgresql_password@lf-postgresql/lingua_finder \
  --from-literal=MONGODB_URI=mongodb://lingua_finder:$mongodb_password@lf-mongodb/lingua_finder \
  --from-literal=REDIS_URL=redis://:$redis_password@lf-redis-master/0 \
  --namespace=${namespace}

kubectl create secret generic mongodb \
  --from-literal=mongodb-passwords=$mongodb_password \
  --from-literal=mongodb-root-password=$mongodb_password \
  --namespace=${namespace}

kubectl create secret generic postgresql \
  --from-literal=password=$postgresql_password \
  --namespace=${namespace}

kubectl create secret generic redis \
  --from-literal=user-password=$redis_password \
  --namespace=${namespace}
