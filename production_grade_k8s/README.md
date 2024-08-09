# Production Grade Kubernetes

Building a production ready self managed kubernetes(k8s) has dependencies on multiple Layers stated below. We will consider two teams i.e., Producer and Consumer. The below design is from Producer team and cluster will be built by Producer team. Consumer team is the one who will use cluster to deploy their workloads.

## Considerations

- Resilency for control nodes. Cluster will have 3 control nodes.
- Minimum 2 Worker nodes for BAU(business as usual) activity anytime on one worker Node.
- cost-effective solution.

## Infrastructure

### Virtual

Create 3 VMS for control node with below spec:

| component | size |
| ------ | ------ |
| RAM | 32GB |
| CPU | 16 cores |
| Storage | 128GB |

Create 2 VMS for worker node with below spec:

| component | size |
| ------ | ------ |
| RAM | 64GB |
| CPU | 32 cores |
| Storage | 256GB |

Additionally:
- Each VM should have unique hostname, MAC address, and product_uuid.
- 2 Network interfaces.
- swap memory should be disabled on each VM.

## DataLink

Two VLAN will be created i.e., Data VLAN(consider 701) and Management VLAN(consider 702). All the VMs one port will be part of Data VLAN and other part of Management VLAN.

## Network

Management network will be reachable from ONLY Producer team(since they build the cluster).
Data network will be reachable from both Producer and Consumer team.

## Compute

- OS(Ubuntu 24.04) will be installed on VM's.
- We could use one of the method to build kubernetes clusters i.e., kubeadm(Opensource) or Manual(Opensource) or pf9(Vendor) etc
  - kubeadm automates kubernetes installation. Quick to setup but limited customization.
  - Manual way involves manually downloading the component, generating client/server certificates and using them to run. Complex to setup but provides high customization.
  - Pf9 is a vendor based solution and would cost us.
- Lets consider our environment supports kubeadm way of installation and hence we select kubeadm way to install kubernetes cluster.
- Next, we will install a container runtime. Lets select crio due to lightweight, simple and direct integration with kubelet. 
- Further we install kubernetes(1.30.3) as per instructions in official guide https://kubernetes.io/docs/reference/setup-tools/kubeadm/

## CNI

- We will use Calico(Opensource) as the CNI due to its high performance and horizontal scaling.
- Pod networks will not be routed encouraging to use Kubernetes service which provides LoadBalancer functionality.
- ExternalIP network will be routed. 

## CSI

- We will use Glusterfs(Opensource) as the CSI due to horizontal scaling, redundancy and flexibility in handling growing number of storage nodes.
- A group of hosts as storage backend glusterfs nodes.
- A StorageClass will be created in k8s cluster which allow Consumers to dynamically provision PV.

## Monitoring

- Install monitoring components on cluster like Prometheus and grafana. 
- Write alerting rules and configure alert manager to send alert to either grafana or a custom system. Lets consider Grafana and we could configure to view the alerts and also integrate notification to slack/webhook.
- Allows effective time utilization by allowing Producer team not to constantly check Grafana for alerts and only check when there is a slack notification. 

## Security

- Create Roles for consumers. Example: exec, read-only, read-write etc
- Network Policy can be defined to avoid cross namespace traffic considering multiple Consumers would be using the same cluster to run their applications on their namespace.

## Cluster Accessibility

- As part of consumer onboarding, Producer team can create a kubeconfig file for Consumer based on the type of access needed by creating a rolebinding to bind the role to user account and generating a kubeconfig file which will be shared to the user. This approach is not good and as the consumer increases it would be better to use an [identity provider].
- kubeconfig will be used in Consumer Jumphost to access the k8s cluster.

