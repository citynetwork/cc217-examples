provider "openstack" {
  region = "Kna1"
  auth_url = "https://kna1.citycloud.com:5000/v3"
}

provider "openstack" {
  alias = "right"
  region = "Fra1"
  auth_url = "https://fra1.citycloud.com:5000/v3"
}

