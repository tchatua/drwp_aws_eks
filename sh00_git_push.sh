#!/bin/bash 

 
git add g01_karpenter/README.md
git add sh00_git_push.sh
git add sh01_create_vpc_eksaddons_dataplane_aws_infra.sh
git add sh02_delete_dataplane_eksaddon_vpce_aws_infra.sh
git add sh03_patch_public_subnet.sh
git add sh04_update_kubeconfig.sh



git commit -m "Bash Scripting files Updated"


git push --set-upstream origin helmdev
