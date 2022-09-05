terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.7.0"
    }
  }
}

data "nutanix_cluster" "cluster" {
  name = var.cluster_name
}
data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

variable "image_name_webserver" {
    type = string
    default = "ubuntu_final"
  
}

## Web Server Fetching the image information ##

data "nutanix_image" "image_info_webserver" {
  image_name = var.image_name_webserver
}

provider "nutanix" {
  username     = var.user
  password     = var.password
  endpoint     = var.endpoint
  insecure     = true
  wait_timeout = 60
}

resource "nutanix_virtual_machine" "vm" {
  name                 = "MyVM from the Terraform Nutanix Provider"
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = "2"
  num_sockets          = "1"
  memory_size_mib      = 1024

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = nutanix_image.image.id
    }
  }

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.image_info_webserver.id
    }

    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }
    }
  }

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }
}
