provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

module "terraform-intersight-iks" {

  source  = "terraform-cisco-modules/iks/intersight//"
  version = "2.1.31"

  # Kubernetes Cluster Profile  Adjust the values as needed.
  cluster = {
    name   = "iks-cluster-01"
    action = "Deploy"
    # action		= "Unassign"
    wait_for_completion = false
    worker_nodes        = 1
    load_balancers      = 1
    worker_max          = 2
    control_nodes       = 1
    ssh_user            = "iksadmin"
    ssh_public_key      = var.ssh_key
  }

  # IP Pool Information (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  ip_pool = {
    use_existing        = false
    name                = "iks-cluster-pool"
    ip_starting_address = "10.52.233.110"
    ip_pool_size        = "10"
    ip_netmask          = "255.255.252.0"
    ip_gateway          = "10.52.232.1"
    dns_servers         = ["144.254.71.184"]
  }


  # Sysconfig Policy (UI Reference NODE OS Configuration) (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  sysconfig = {
    use_existing = false
    name         = "iks-cluster-sysconfig"
    domain_name  = "olympus.io"
    timezone     = "Europe/London"
    ntp_servers  = ["10.50.136.1"]
    dns_servers  = ["144.254.71.184"]
  }

  # Kubernetes Network CIDR (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  k8s_network = {
    use_existing = false
    name         = "iks-cluster-network"

    ######### Below are the default settings.  Change if needed. #########
    pod_cidr     = "100.65.0.0/16"
    service_cidr = "100.64.0.0/24"
    cni          = "Calico"
  }

  # Version policy (To create new change "useExisting" to 'false' uncomment variables and modify them to meet your needs.)
  versionPolicy = {
    useExisting    = false
    iksVersionName = "1.20.14-iks.0"
    policyName     = "iks-cluster-version"
  }

  # Trusted Registry Policy (To create new change "use_existing" to 'false' and set "create_new' to 'true' uncomment variables and modify them to meet your needs.)
  # Set both variables to 'false' if this policy is not needed.
  tr_policy = {
    use_existing = false
    create_new   = false
    # name         = "trusted-registry"
  }

  # Runtime Policy (To create new change "use_existing" to 'false' and set "create_new' to 'true' uncomment variables and modify them to meet your needs.)
  # Set both variables to 'false' if this policy is not needed.
  runtime_policy = {
    use_existing         = false
    create_new           = true
    name                 = "iks-cluster-runtime"
    http_proxy_hostname  = "proxy.esl.cisco.com"
    http_proxy_port      = 80
    http_proxy_protocol  = "http"
    http_proxy_username  = null
    http_proxy_password  = null
    https_proxy_hostname = "proxy.esl.cisco.com"
    https_proxy_port     = 80
    https_proxy_protocol = "https"
    https_proxy_username = null
    https_proxy_password = null
  }

  # Infrastructure Configuration Policy (To create new change "use_existing" to 'false' and uncomment variables and modify them to meet your needs.)
  infraConfigPolicy = {
    use_existing = false
    platformType       = "vcenter"
    policyName  = "iks-cluster-infra"
    description = "iks-cluster-vcenter"
    interfaces         = ["Storage Controller Management Network"]
    vcTargetName       = "10.52.232.60"
    vcClusterName      = "Athena"
    vcDatastoreName    = "Athena_DS1"
    vcResourcePoolName = ""
    vcPassword         = var.vc_password
  }

  # Addon Profile and Policies (To create new change "createNew" to 'true' and uncomment variables and modify them to meet your needs.)
  # This is an Optional item.  Comment or remove to not use.  Multiple addons can be configured.
  #addons = [
  #  {
  #    createNew       = true
  #    addonPolicyName = "iks-cluster-dashboard"
  #    addonName       = "kubernetes-dashboard"
  #   description     = "iks cluster dashboard"
  #    upgradeStrategy = "AlwaysReinstall"
  #    installStrategy = "InstallOnly"
      # releaseVersion = "1.7.4-cisco4-helm3"
      # overrides = yamlencode({"demoApplication":{"enabled":true}})
  #  },
  #  {
  #    createNew       = true
  #    addonPolicyName = "iks-cluster-monitor"
  #    addonName       = "ccp-monitor"
  #    description     = "iks cluster monitor"
  #    upgradeStrategy = "AlwaysReinstall"
  #    installStrategy = "InstallOnly"
      # releaseVersion = "0.2.61-helm3"
      # overrides = yamlencode({"demoApplication":{"enabled":true}})
  #  }
 # ]

  # Worker Node Instance Type (To create new change "use_existing" to 'false' and uncomment variables and modify them to meet your needs.)
  instance_type = {
    use_existing = false
    name         = "iks-cluster-instance"
    # cpu          = 4
    # memory       = 16386
    # disk_size    = 40
  }

  # Organization and Tag Information
  organization = var.organization
  tags         = var.tags
}
