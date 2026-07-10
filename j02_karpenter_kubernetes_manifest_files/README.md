# Karpenter Configuration (Layer 4)

**Purpose:** Define how Karpenter provisions nodes

```yml
# a01_ec2nodeclass.yaml
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default-ec2nodeclass
spec:
  # Recommended for EKS-managed Amazon Linux 2023 AMIs
  amiFamily: AL2023

  amiSelectorTerms:
    - alias: al2023@latest

  # Node IAM role created in Terraform
  # role: "arn:aws:iam::180789647333:role/retail-dev-karpenter-node-role"
  role: "arn:aws:iam::088354478627:role/drwp-dev-karpenter-node-role"

  # Auto-discover subnets (your cluster tags)
  subnetSelectorTerms:
    - tags:
        # kubernetes.io/cluster/retail-dev-eksdemo1: owned
        kubernetes.io/cluster/eks-control-plane: owned
        kubernetes.io/role/internal-elb: "1"

  # Auto-discover security groups
  securityGroupSelectorTerms:
    - tags:
        # kubernetes.io/cluster/retail-dev-eksdemo1: owned
        kubernetes.io/cluster/eks-control-plane: owned

  # Required for Karpenter auto-discovery of resources
  tags:
    # karpenter.sh/discovery: retail-dev-eksdemo1
    karpenter.sh/discovery: eks-control-plane

  # Recommended EBS configuration
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: 20Gi
        volumeType: gp3
        encrypted: true
        deleteOnTermination: true

  # Recommended IMDS Metadata options
  metadataOptions:
    httpTokens: required
    httpPutResponseHopLimit: 2


  # -------------------------------------------------------------------
  # NOTE ABOUT SUBNET SELECTION:
  #
  # By default, Karpenter discovers *all* subnets that contain the
  # cluster tag:
  #
  #   kubernetes.io/cluster/<cluster-name> = owned
  #
  # Since this tag exists on BOTH public and private subnets, Karpenter
  # may accidentally provision worker nodes in PUBLIC subnets, which
  # gives EC2 instances public IP addresses (NOT secure).
  #
  # To enforce a private-only Kubernetes data plane, we add an extra
  # filter:
  #
  #   kubernetes.io/role/internal-elb = "1"
  #
  # This tag exists ONLY on private subnets (created for internal load
  # balancers), so Karpenter will launch nodes **exclusively in private
  # subnets**, with NO public IPs — matching enterprise security
  # standards.
  # Use this filter ALWAYS in production clusters for node provisioning.
  # -------------------------------------------------------------------
```

## On-Demand NodePool

```yml
# a02_nodepool_ondemand.yaml
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: ondemand-nodepool
spec:
  template:
    spec:
      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: default-ec2nodeclass
      # No taints for now (you can add later)
      taints: []
      startupTaints: []
      # Node selection logic
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
        - key: kubernetes.io/os
          operator: In
          values: ["linux"]    
        # Default = on-demand: If not specified, capacity type defaults to on-demand
        # Explicitly specify on-demand (best practice)
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["on-demand"]   # More expensive but stable       
        # Cheaper, smaller instance families
        - key: karpenter.k8s.aws/instance-family
          operator: In
          values: ["t3", "t3a"]  # All burstable, budget-friendly
        # Limit to smaller sizes only
        - key: karpenter.k8s.aws/instance-size
          operator: In
          values: ["micro", "small", "medium", "large"]  # Caps at t3.medium (2 vCPU, 4GB RAM)
        # Must match the AZs where your EKS cluster has subnets configured
        # Karpenter can only launch nodes in AZs with configured VPC subnets
        - key: topology.kubernetes.io/zone
          operator: In
          values: ["us-east-2a", "us-east-2b", "us-east-2c"]  
  # Cluster-wide max scaling limit
  limits:
    cpu: "50" # Hard limit
  # Recommended disruption settings
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 30s  # How long to wait before consolidating
```

## Spot NodePool

```yml
# a03_nodepool_spot.yaml
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: spot-nodepool
spec:
  template:
    spec:
      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: default-ec2nodeclass
      taints: []
      startupTaints: []
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
        - key: kubernetes.io/os
          operator: In
          values: ["linux"]
        # Spot capacity (50-90% cheaper than on-demand)
        # Note: Spot instances can be interrupted with 2-minute notice
        # Best for fault-tolerant, stateless workloads, CI/CD Pipeline (Dev, Test Environment), Batch, Data Processing      
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["spot"]
        # Multiple instance families for better spot availability
        - key: karpenter.k8s.aws/instance-family
          operator: In
          values: ["t3", "t3a", "t2", "c5a", "c6a"]
        # Allow micro to large - flexibility helps find available spot capacity
        - key: karpenter.k8s.aws/instance-size
          operator: In
          values: ["micro", "small", "medium", "large"]
        # Must match the AZs where your EKS cluster has subnets configured
        # Karpenter can only launch nodes in AZs with configured VPC subnets
        - key: topology.kubernetes.io/zone
          operator: In
          values: ["us-east-1a", "us-east-1b", "us-east-1c"]
  limits:
    cpu: "50"
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 30s
    # Add budgets to control disruption rate
    budgets:
      - nodes: "100%"  # Allow all nodes to be disrupted if needed
        reasons:
          - "Drifted"
          - "Underutilized"
          - "Empty"    
```

## Deploy and Verify Nodepools

```sh
# Deploy Nodepools
kubectl apply -f 02_nodepool_ondemand.yaml
kubectl apply -f 03_nodepool_spot.yaml

# List Nodepools
kubectl get nodepools

# Expected:
# NAME                READY   AGE
# ondemand-nodepool   True    5m
# spot-nodepool       True    5m


# Describe Nodepools
kubectl describe nodepool ondemand-nodepool
kubectl describe nodepool spot-nodepool
```

> Outputs

```sh
# ###################################################################################################

kubectl apply -f a01_karpenter_K8s_Manifests/
ec2nodeclass.karpenter.k8s.aws/default-ec2nodeclass created
nodepool.karpenter.sh/ondemand-nodepool created
nodepool.karpenter.sh/spot-nodepool created

# ###################################################################################################

kubectl get ec2nodeclass
NAME                   READY   AGE
default-ec2nodeclass   True    92s

# ###################################################################################################

kubectl describe ec2nodeclass default-ec2nodeclass
Name:         default-ec2nodeclass
Namespace:
Labels:       <none>
Annotations:  karpenter.k8s.aws/ec2nodeclass-hash: 6409880261969345973
              karpenter.k8s.aws/ec2nodeclass-hash-version: v4
API Version:  karpenter.k8s.aws/v1
Kind:         EC2NodeClass
Metadata:
  Creation Timestamp:  2026-07-08T11:10:51Z
  Finalizers:
    karpenter.k8s.aws/termination
  Generation:        1
  Resource Version:  159462
  UID:               e9a6a6ec-a00f-48c6-8012-e417ea076fa2
Spec:
  Ami Family:  AL2023
  Ami Selector Terms:
    Alias:  al2023@latest
  Block Device Mappings:
    Device Name:  /dev/xvda
    Ebs:
      Delete On Termination:  true
      Encrypted:              true
      Volume Size:            20Gi
      Volume Type:            gp3
  Metadata Options:
    Http Endpoint:                enabled
    httpProtocolIPv6:             disabled
    Http Put Response Hop Limit:  2
    Http Tokens:                  required
  Role:                           arn:aws:iam::088354478627:role/drwp-dev-karpenter-node-role
  Security Group Selector Terms:
    Tags:
      kubernetes.io/cluster/eks-control-plane:  owned
  Subnet Selector Terms:
    Tags:
      kubernetes.io/cluster/eks-control-plane:  owned
      kubernetes.io/role/internal-elb:          1
  Tags:
    karpenter.sh/discovery:  eks-control-plane
Status:
  Amis:
    Id:    ami-0c4f311117335b8ab
    Name:  amazon-eks-node-al2023-arm64-standard-1.34-v20260625
    Requirements:
      Key:       kubernetes.io/arch
      Operator:  In
      Values:
        arm64
      Key:       karpenter.k8s.aws/instance-gpu-count
      Operator:  DoesNotExist
      Key:       karpenter.k8s.aws/instance-accelerator-count
      Operator:  DoesNotExist
    Id:          ami-007e7eab2ec596e0d
    Name:        amazon-eks-node-al2023-x86_64-neuron-1.34-v20260625
    Requirements:
      Key:       kubernetes.io/arch
      Operator:  In
      Values:
        amd64
      Key:       karpenter.k8s.aws/instance-accelerator-count
      Operator:  Exists
    Id:          ami-0100be2def7825eb6
    Name:        amazon-eks-node-al2023-x86_64-standard-1.34-v20260625
    Requirements:
      Key:       kubernetes.io/arch
      Operator:  In
      Values:
        amd64
      Key:       karpenter.k8s.aws/instance-gpu-count
      Operator:  DoesNotExist
      Key:       karpenter.k8s.aws/instance-accelerator-count
      Operator:  DoesNotExist
    Id:          ami-0514962db6f5d278c
    Name:        amazon-eks-node-al2023-arm64-nvidia-1.34-v20260625
    Requirements:
      Key:       kubernetes.io/arch
      Operator:  In
      Values:
        arm64
      Key:       karpenter.k8s.aws/instance-gpu-count
      Operator:  Exists
    Id:          ami-059a9598ae72fb3e2
    Name:        amazon-eks-node-al2023-x86_64-nvidia-1.34-v20260625
    Requirements:
      Key:       kubernetes.io/arch
      Operator:  In
      Values:
        amd64
      Key:       karpenter.k8s.aws/instance-gpu-count
      Operator:  Exists
  Conditions:
    Last Transition Time:  2026-07-08T11:10:51Z
    Message:
    Observed Generation:   1
    Reason:                AMIsReady
    Status:                True
    Type:                  AMIsReady
    Last Transition Time:  2026-07-08T11:10:51Z
    Message:
    Observed Generation:   1
    Reason:                CapacityReservationsReady
    Status:                True
    Type:                  CapacityReservationsReady
    Last Transition Time:  2026-07-08T11:10:52Z
    Message:
    Observed Generation:   1
    Reason:                SubnetsReady
    Status:                True
    Type:                  SubnetsReady
    Last Transition Time:  2026-07-08T11:10:52Z
    Message:
    Observed Generation:   1
    Reason:                SecurityGroupsReady
    Status:                True
    Type:                  SecurityGroupsReady
    Last Transition Time:  2026-07-08T11:10:52Z
    Message:
    Observed Generation:   1
    Reason:                InstanceProfileReady
    Status:                True
    Type:                  InstanceProfileReady
    Last Transition Time:  2026-07-08T11:11:00Z
    Message:
    Observed Generation:   1
    Reason:                ValidationSucceeded
    Status:                True
    Type:                  ValidationSucceeded
    Last Transition Time:  2026-07-08T11:11:00Z
    Message:
    Observed Generation:   1
    Reason:                Ready
    Status:                True
    Type:                  Ready
  Instance Profile:        eks-control-plane_8111525774605854343
  Security Groups:
    Id:    sg-0896cc29e97573ea2
    Name:  eks-cluster-sg-eks-control-plane-539728044
  Subnets:
    Id:       subnet-037489b0725fabe93
    Zone:     us-east-2c
    Zone ID:  use2-az3
    Id:       subnet-0739442a734c80426
    Zone:     us-east-2a
    Zone ID:  use2-az1
    Id:       subnet-0a045721ae0be0436
    Zone:     us-east-2b
    Zone ID:  use2-az2
Events:
  Type    Reason                     Age    From       Message
  ----    ------                     ----   ----       -------
  Normal  AMIsReady                  4m1s   karpenter  Status condition transitioned, Type: AMIsReady, Status: Unknown -> True, Reason: AMIsReady
  Normal  CapacityReservationsReady  4m1s   karpenter  Status condition transitioned, Type: CapacityReservationsReady, Status: Unknown -> True, Reason: CapacityReservationsReady
  Normal  SubnetsReady               4m1s   karpenter  Status condition transitioned, Type: SubnetsReady, Status: Unknown -> True, Reason: SubnetsReady
  Normal  SecurityGroupsReady        4m1s   karpenter  Status condition transitioned, Type: SecurityGroupsReady, Status: Unknown -> True, Reason: SecurityGroupsReady
  Normal  InstanceProfileReady       4m1s   karpenter  Status condition transitioned, Type: InstanceProfileReady, Status: Unknown -> True, Reason: InstanceProfileReady
  Normal  ValidationSucceeded        3m54s  karpenter  Status condition transitioned, Type: ValidationSucceeded, Status: Unknown -> True, Reason: ValidationSucceeded
  Normal  Ready                      3m54s  karpenter  Status condition transitioned, Type: Ready, Status: Unknown -> True, Reason: Ready

# ###################################################################################################

kubectl get nodepools
NAME                NODECLASS              NODES   READY   AGE
ondemand-nodepool   default-ec2nodeclass   0       True    6m24s
spot-nodepool       default-ec2nodeclass   0       True    6m24s

# ###################################################################################################

kubectl describe nodepools ondemand-nodepool
Name:         ondemand-nodepool
Namespace:
Labels:       <none>
Annotations:  karpenter.sh/nodepool-hash: 11142864721958693070
              karpenter.sh/nodepool-hash-version: v3
API Version:  karpenter.sh/v1
Kind:         NodePool
Metadata:
  Creation Timestamp:  2026-07-08T11:10:51Z
  Generation:          1
  Resource Version:    159464
  UID:                 5a37586c-505c-40a5-8183-88edbadc5e0a
Spec:
  Disruption:
    Budgets:
      Nodes:               10%
    Consolidate After:     30s
    Consolidation Policy:  WhenEmptyOrUnderutilized
  Limits:
    Cpu:  50
  Template:
    Spec:
      Expire After:  720h
      Node Class Ref:
        Group:  karpenter.k8s.aws
        Kind:   EC2NodeClass
        Name:   default-ec2nodeclass
      Requirements:
        Key:       kubernetes.io/arch
        Operator:  In
        Values:
          amd64
        Key:       kubernetes.io/os
        Operator:  In
        Values:
          linux
        Key:       karpenter.sh/capacity-type
        Operator:  In
        Values:
          on-demand
        Key:       karpenter.k8s.aws/instance-family
        Operator:  In
        Values:
          t3
          t3a
        Key:       karpenter.k8s.aws/instance-size
        Operator:  In
        Values:
          micro
          small
          medium
          large
        Key:       topology.kubernetes.io/zone
        Operator:  In
        Values:
          us-east-2a
          us-east-2b
          us-east-2c
      Startup Taints:
      Taints:
Status:
  Conditions:
    Last Transition Time:          2026-07-08T11:10:51Z
    Message:                       object is awaiting reconciliation
    Observed Generation:           1
    Reason:                        AwaitingReconciliation
    Status:                        Unknown
    Type:                          NodeRegistrationHealthy
    Last Transition Time:          2026-07-08T11:10:51Z
    Message:
    Observed Generation:           1
    Reason:                        ValidationSucceeded
    Status:                        True
    Type:                          ValidationSucceeded
    Last Transition Time:          2026-07-08T11:11:00Z
    Message:
    Observed Generation:           1
    Reason:                        NodeClassReady
    Status:                        True
    Type:                          NodeClassReady
    Last Transition Time:          2026-07-08T11:11:00Z
    Message:
    Observed Generation:           1
    Reason:                        Ready
    Status:                        True
    Type:                          Ready
  Node Class Observed Generation:  1
  Nodes:                           0
  Resources:
    Cpu:                  0
    Ephemeral - Storage:  0
    Memory:               0
    Nodes:                0
    Pods:                 0
Events:
  Type    Reason               Age    From       Message
  ----    ------               ----   ----       -------
  Normal  ValidationSucceeded  7m11s  karpenter  Status condition transitioned, Type: ValidationSucceeded, Status: Unknown -> True, Reason: ValidationSucceeded
  Normal  NodeClassReady       7m10s  karpenter  Status condition transitioned, Type: NodeClassReady, Status: Unknown -> False, Reason: NodeClassReadinessUnknown, Message: Node Class Readiness Unknown
  Normal  Ready                7m10s  karpenter  Status condition transitioned, Type: Ready, Status: Unknown -> False, Reason: UnhealthyDependents, Message: NodeClassReady=False
  Normal  NodeClassReady       7m2s   karpenter  Status condition transitioned, Type: NodeClassReady, Status: False -> True, Reason: NodeClassReady
  Normal  Ready                7m2s   karpenter  Status condition transitioned, Type: Ready, Status: False -> True, Reason: Ready

# ###################################################################################################

kubectl describe nodepools spot-nodepool
Name:         spot-nodepool
Namespace:
Labels:       <none>
Annotations:  karpenter.sh/nodepool-hash: 11142864721958693070
              karpenter.sh/nodepool-hash-version: v3
API Version:  karpenter.sh/v1
Kind:         NodePool
Metadata:
  Creation Timestamp:  2026-07-08T11:10:51Z
  Generation:          1
  Resource Version:    159466
  UID:                 0f4963fb-74f8-49df-a2be-15ea3faa2d5c
Spec:
  Disruption:
    Budgets:
      Nodes:  100%
      Reasons:
        Drifted
        Underutilized
        Empty
    Consolidate After:     30s
    Consolidation Policy:  WhenEmptyOrUnderutilized
  Limits:
    Cpu:  50
  Template:
    Spec:
      Expire After:  720h
      Node Class Ref:
        Group:  karpenter.k8s.aws
        Kind:   EC2NodeClass
        Name:   default-ec2nodeclass
      Requirements:
        Key:       kubernetes.io/arch
        Operator:  In
        Values:
          amd64
        Key:       kubernetes.io/os
        Operator:  In
        Values:
          linux
        Key:       karpenter.sh/capacity-type
        Operator:  In
        Values:
          spot
        Key:       karpenter.k8s.aws/instance-family
        Operator:  In
        Values:
          t3
          t3a
          t2
          c5a
          c6a
        Key:       karpenter.k8s.aws/instance-size
        Operator:  In
        Values:
          micro
          small
          medium
          large
        Key:       topology.kubernetes.io/zone
        Operator:  In
        Values:
          us-east-1a
          us-east-1b
          us-east-1c
      Startup Taints:
      Taints:
Status:
  Conditions:
    Last Transition Time:          2026-07-08T11:10:51Z
    Message:
    Observed Generation:           1
    Reason:                        ValidationSucceeded
    Status:                        True
    Type:                          ValidationSucceeded
    Last Transition Time:          2026-07-08T11:10:52Z
    Message:                       object is awaiting reconciliation
    Observed Generation:           1
    Reason:                        AwaitingReconciliation
    Status:                        Unknown
    Type:                          NodeRegistrationHealthy
    Last Transition Time:          2026-07-08T11:11:00Z
    Message:
    Observed Generation:           1
    Reason:                        NodeClassReady
    Status:                        True
    Type:                          NodeClassReady
    Last Transition Time:          2026-07-08T11:11:00Z
    Message:
    Observed Generation:           1
    Reason:                        Ready
    Status:                        True
    Type:                          Ready
  Node Class Observed Generation:  1
  Nodes:                           0
  Resources:
    Cpu:                  0
    Ephemeral - Storage:  0
    Memory:               0
    Nodes:                0
    Pods:                 0
Events:
  Type    Reason               Age    From       Message
  ----    ------               ----   ----       -------
  Normal  ValidationSucceeded  9m6s   karpenter  Status condition transitioned, Type: ValidationSucceeded, Status: Unknown -> True, Reason: ValidationSucceeded
  Normal  NodeClassReady       9m5s   karpenter  Status condition transitioned, Type: NodeClassReady, Status: Unknown -> False, Reason: NodeClassReadinessUnknown, Message: Node Class Readiness Unknown
  Normal  Ready                9m5s   karpenter  Status condition transitioned, Type: Ready, Status: Unknown -> False, Reason: UnhealthyDependents, Message: NodeClassReady=False
  Normal  NodeClassReady       8m57s  karpenter  Status condition transitioned, Type: NodeClassReady, Status: False -> True, Reason: NodeClassReady
  Normal  Ready                8m57s  karpenter  Status condition transitioned, Type: Ready, Status: False -> True, Reason: Ready
```

## Verify Karpenter Pods Logs

```sh
kubectl get pods -n kube-system -l app.kubernetes.io/name=karpenter
NAME                         READY   STATUS    RESTARTS      AGE
karpenter-779fc6f565-dzfj7   1/1     Running   1 (14m ago)   14m
karpenter-779fc6f565-s9mg2   1/1     Running   2 (14m ago)   14m

# ###################################################################################################
# View logs from all Karpenter pods
kubectl logs -n kube-system -l app.kubernetes.io/name=
# Follow logs in real time
kubectl logs -f -n kube-system -l app.kubernetes.io/name=karpenter

# ###################################################################################################

# Watch Karpenter in action
kubectl logs -n kube-system -l app.kubernetes.io/name=karpenter -f

# Check Karpenter controller version
kubectl get deployment -n kube-system karpenter -o jsonpath='{.spec.template.spec.containers[0].image}'

# See all Karpenter-managed nodes
kubectl get nodes -l karpenter.sh/nodepool

# See node provisioning details
kubectl get nodeclaims -o wide

# Check Karpenter metrics (Metrics server EKS Addon should be installed)
kubectl top pods -n kube-system -l app.kubernetes.io/name=karpenter

# Debug specific nodeclaim
kubectl describe nodeclaim <name>

# Check consolidation decisions
kubectl logs -n kube-system -l app.kubernetes.io/name=karpenter | grep consolidation

# ###################################################################################################

kubectl logs -n kube-system -l app.kubernetes.io/name=karpenter -f
{"level":"INFO","time":"2026-07-08T11:08:10.645Z","logger":"controller.controller-runtime.metrics","message":"Starting metrics server","commit":"f913f41"}
{"level":"INFO","time":"2026-07-08T11:08:10.645Z","logger":"controller.controller-runtime.metrics","message":"Serving metrics server","commit":"f913f41","bindAddress":":8080","secure":false}
{"level":"INFO","time":"2026-07-08T11:08:10.645Z","logger":"controller","message":"starting server","commit":"f913f41","name":"health probe","addr":"[::]:8081"}
{"level":"INFO","time":"2026-07-08T11:08:10.747Z","logger":"controller","message":"attempting to acquire leader lease kube-system/karpenter-leader-election...","commit":"f913f41"}
{"level":"INFO","time":"2026-07-08T11:08:07.074Z","logger":"controller","message":"Starting workers","commit":"f913f41","controller":"nodeclaim.disruption","controllerGroup":"karpenter.sh","controllerKind":"NodeClaim","worker count":10}
{"level":"INFO","time":"2026-07-08T11:08:07.075Z","logger":"controller","message":"Starting Controller","commit":"f913f41","controller":"nodepool.readiness","controllerGroup":"karpenter.sh","controllerKind":"NodePool"}
{"level":"INFO","time":"2026-07-08T11:08:07.075Z","logger":"controller","message":"Starting workers","commit":"f913f41","controller":"nodepool.readiness","controllerGroup":"karpenter.sh","controllerKind":"NodePool","worker count":10}
{"level":"INFO","time":"2026-07-08T11:08:07.075Z","logger":"controller","message":"Starting Controller","commit":"f913f41","controller":"nodepool.registrationhealth","controllerGroup":"karpenter.sh","controllerKind":"NodePool"}
{"level":"INFO","time":"2026-07-08T11:08:07.075Z","logger":"controller","message":"Starting workers","commit":"f913f41","controller":"nodepool.registrationhealth","controllerGroup":"karpenter.sh","controllerKind":"NodePool","worker count":10}
{"level":"INFO","time":"2026-07-08T11:10:51.782Z","logger":"controller","message":"discovered ssm parameter","commit":"f913f41","controller":"nodeclass","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass","EC2NodeClass":{"name":"default-ec2nodeclass"},"namespace":"","name":"default-ec2nodeclass","reconcileID":"f227341b-bb59-487c-ab7e-e553ab4c06e7","parameter":"/aws/service/eks/optimized-ami/1.34/amazon-linux-2023/x86_64/standard/recommended/image_id","value":"ami-0100be2def7825eb6"}
{"level":"INFO","time":"2026-07-08T11:10:51.800Z","logger":"controller","message":"discovered ssm parameter","commit":"f913f41","controller":"nodeclass","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass","EC2NodeClass":{"name":"default-ec2nodeclass"},"namespace":"","name":"default-ec2nodeclass","reconcileID":"f227341b-bb59-487c-ab7e-e553ab4c06e7","parameter":"/aws/service/eks/optimized-ami/1.34/amazon-linux-2023/x86_64/nvidia/recommended/image_id","value":"ami-059a9598ae72fb3e2"}
{"level":"INFO","time":"2026-07-08T11:10:51.816Z","logger":"controller","message":"discovered ssm parameter","commit":"f913f41","controller":"nodeclass","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass","EC2NodeClass":{"name":"default-ec2nodeclass"},"namespace":"","name":"default-ec2nodeclass","reconcileID":"f227341b-bb59-487c-ab7e-e553ab4c06e7","parameter":"/aws/service/eks/optimized-ami/1.34/amazon-linux-2023/x86_64/neuron/recommended/image_id","value":"ami-007e7eab2ec596e0d"}
{"level":"INFO","time":"2026-07-08T11:10:51.837Z","logger":"controller","message":"discovered ssm parameter","commit":"f913f41","controller":"nodeclass","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass","EC2NodeClass":{"name":"default-ec2nodeclass"},"namespace":"","name":"default-ec2nodeclass","reconcileID":"f227341b-bb59-487c-ab7e-e553ab4c06e7","parameter":"/aws/service/eks/optimized-ami/1.34/amazon-linux-2023/arm64/standard/recommended/image_id","value":"ami-0c4f311117335b8ab"}
{"level":"INFO","time":"2026-07-08T11:10:51.859Z","logger":"controller","message":"discovered ssm parameter","commit":"f913f41","controller":"nodeclass","controllerGroup":"karpenter.k8s.aws","controllerKind":"EC2NodeClass","EC2NodeClass":{"name":"default-ec2nodeclass"},"namespace":"","name":"default-ec2nodeclass","reconcileID":"f227341b-bb59-487c-ab7e-e553ab4c06e7","parameter":"/aws/service/eks/optimized-ami/1.34/amazon-linux-2023/arm64/nvidia/recommended/image_id","value":"ami-0514962db6f5d278c"}

```