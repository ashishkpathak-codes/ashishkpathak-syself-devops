# Busybox

[busybox](./busybox) is a Production grade helm chart created to deploy busybox application as a web server(backend). It includes test suite allowing user to be able to invoke command to run test.

>Note: This chart is completely made from scratch by the Author: Ashish K Pathak.

## Features

- Chart can be installed on any namespace.
- Test included to check busybox web server availability.
- Includes notes after installation giving user information on accessing application.
- values.yaml can be modified for replicas, registry, port etc to update the chart installation as per k8s platform.

## Installation

Install [busybox](./busybox) chart. Installs on default namespace.
```sh
helm install busybox --generate-name
```

Install [busybox](./busybox) chart on namespace bar as foo
```sh
helm install bar busybox -n foo
```

Install [busybox](./busybox) chart with 3 replicas of busybox application.
```sh
helm install busybox --generate-name --set replicaCount=3
```

## Test

Run test after installation
```sh
helm test bar -n foo
```

## Uninstallation

Uninstall a release
```sh
helm uninstall <releaseName>
```

# Database Considerations

There are some options:
- Managed database service from Public Cloud provider ex: AWS RDS
- Deploying database as statefulset in kubernetes cluster via Helm or Gitops.
- Running VM based self managed database cluster. 

## Factors

- Database should be prod ready.
- Database should be cost effective.

## Approach

Since we are considering for production and above [Factors](#factors), it would be recommended to start with the Managed database service which provides features like backup, patching and scaling. Once we have it up and running, we can plan the below to reduce the cost since running on Public Cloud for a longer time incurrs higher cost and provided Enterprise has a Private Cloud:

- Check for features like sharding, failover elections and replication provided by Database. If so, then hosting deployment on kubernetes may be a choice and if not standlone VM based deployment would be a choice.
- Check for team proficiency in database administration from operations point of view.

## Migration

We will achieve migration from Public Cloud to Private Cloud by following the below:

- Traffic Splitting, a percent of the database queries made by the backend application should be redirected to Private Cloud Enterprise database. 
- We could monitor grafana for database query error rate and based on that we can continue to increase percent of traffic towards Private cloud resulting in slowly migrating 100% of traffic to Private Cloud.

## Enhancements

It would be recommended to add a Cache service. Backend application can write to Cache service on first query from database and further queries can be checked from cache(cache hit) which would increase the performance. Cache invalidation can be implemented for this in backend along with timer for cache entries. This also reduces the cost w.r.t database. 
