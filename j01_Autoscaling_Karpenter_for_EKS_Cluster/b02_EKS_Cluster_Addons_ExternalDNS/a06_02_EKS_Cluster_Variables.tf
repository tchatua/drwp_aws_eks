# --------------------------------------------
# EKS Cluster Variables
# --------------------------------------------
variable "cluster_name" {
  description = "The name of the EKS cluster. Also used as a prefix in names of related resources"
  type        = string
  default     = "njekscluster"
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster(e.g. 1.28, 1.29)"
  type        = string
  default     = null # Defaults to the latest supported Kubernetes version if not specified
}

variable "cluster_service_ipv4_cidr" {
  description = "The IPv4 CIDR block for the EKS cluster's service endpoints"
  type        = string
  default     = null
}

variable "cluster_endpoint_private_access" {
  description = "Whether to enable private access to EKS control plane endpoint"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Whether to enable public access to EKS control plane endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks allowed to access the EKS control plane endpoint when public access is enabled"
  type        = list(string)
  default     = ["173.61.6.206/32"] # Replace with your IP or CIDR block for secure access

}


# --------------------------------------------
# 
# --------------------------------------------

