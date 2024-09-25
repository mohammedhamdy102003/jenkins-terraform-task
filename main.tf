terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13"  
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}
variable "number_of_containers" {
  type    = number
  default = 1
}

variable "image_name" {
  type    = string
  default = "nginx"
}

variable "image_version" {
  type    = string
  default = "latest"
}

resource "docker_image" "nginx" {
  name = "${var.image_name}:${var.image_version}"
}

resource "docker_container" "nginx_containers" {
  count = var.number_of_containers
  image = docker_image.nginx.latest
  name  = "nginx-${count.index + 1}"
  ports {
    internal = 80
    external = "800+${count.index + 1}"
  }
}
