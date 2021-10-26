provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

module "terraform-intersight-iks" {
  source = "terraform-cisco-modules/iks/intersight"
  version = "2.0.3"

  ip_pool = {
    use_existing        = true
    name                = "iks-terraform-ip-pool"
    ip_starting_address = "10.52.233.86"
    ip_pool_size        = "15"
    ip_netmask          = "255.255.252.0"
    ip_gateway          = "10.52.232.1"
    dns_servers         = ["144.254.71.184"]
  }

  sysconfig = {
    use_existing = false
    name         = "New"
    domain_name  = "olympus.io"
    timezone     = "Europe/London"
    ntp_servers  = ["10.50.136.1"]
    dns_servers  = ["144.254.71.184"]
  }

  k8s_network = {
    use_existing = false
    name         = "default"

    ######### Below are the default settings.  Change if needed. #########
    pod_cidr     = "100.65.0.0/16"
    service_cidr = "100.64.0.0/24"
    cni          = "Calico"
  }
  # Version policy
  version_policy = {
    use_existing = false
    name         = "1.19.5"
    version      = "1.19.5"
  }

  # tr_policy_name = "test"
  tr_policy = {
    use_existing = false
    create_new   = false
    name         = "triggermesh-trusted-registry"
  }

  runtime_policy = {
    use_existing         = false
    create_new           = false
    name                 = "runtime"
    http_proxy_hostname  = "proxy.esl.cisco.com"
    http_proxy_port      = 80
    http_proxy_protocol  = "http"
    http_proxy_username  = null
    http_proxy_password  = null
    https_proxy_hostname = "proxy.esl.cisco.com"
    https_proxy_port     = 8080
    https_proxy_protocol = "https"
    https_proxy_username = null
    https_proxy_password = null
  }

  # Infra Config Policy Information
  infra_config_policy = {
    use_existing     = false
    name             = "vcenter"
    vc_target_name   = "10.52.232.60"
    vc_portgroups    = ["Storage Controller Management Network"]
    vc_datastore     = "Athena-DS1"
    vc_cluster       = "Athena"
    vc_resource_pool = ""
    vc_password      = var.vc_password
  }

  #addons_list = [
   # {
   #  addon_policy_name = "iks-dashboard"
   #  addon             = "kubernetes-dashboard"
   #  description       = "K8s Dashboard Policy"
   #  upgrade_strategy  = "AlwaysReinstall"
   #  install_strategy  = "InstallOnly"
   #  },
   #  {
   #    addon_policy_name = "iks-monitor"
   #    addon             = "ccp-monitor"
   #    description       = "Grafana Policy"
   #    upgrade_strategy  = "AlwaysReinstall"
   #    install_strategy  = "InstallOnly"
    # }
  #]
  instance_type = {
    use_existing = false
    name         = "small"
    cpu          = 4
    memory       = 16386
    disk_size    = 40
  }
  # Cluster information
  cluster = {
    name                = "iks-zeus01"
    action              = "Deploy"
    wait_for_completion = false
    worker_nodes        = 3
    load_balancers      = 1
    worker_max          = 20
    control_nodes       = 1
    ssh_user            = "iksadmin"
    ssh_public_key      = var.ssh_key
  }
  # Organization and Tag
  organization = var.organization
  tags         = var.tags
}
