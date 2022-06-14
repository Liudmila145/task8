terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "application" {
  name = "liudmila145/application:lasttag"
}

resource "docker_image" "mysql" {
  name = "mysql:8"
}

resource "docker_network" "test-net" {
  name = "test-net"
}

resource "docker_container" "application" {
  image = docker_image.application.latest
  name  = "application"

  ports {
    internal = 80
    external = 9999
  }

  networks_advanced {
    name = docker_network.test-net.name
  }

  depends_on = [docker_network.test-net, docker_container.wordpress-mysql]
}

resource "docker_volume" "mysql-data" {
  name = "mysql-data"
}

resource "docker_container" "wordpress-mysql" {
  image      = docker_image.mysql.latest
  name       = "wordpress-mysql"

  networks_advanced {
    name = docker_network.test-net.name
  }

  env = ["MYSQL_ROOT_PASSWORD=wordpress", "MYSQL_DATABASE=wordpress", "MYSQL_USER=wordpress", "MYSQL_PASSWORD=wordpress"]

  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.mysql-data.name
  }

  depends_on = [docker_network.test-net, docker_volume.mysql-data]
}

