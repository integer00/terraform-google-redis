resource "google_compute_instance" "vm_redis" {
  name         = var.redis_instance_name
  project      = var.project_id
  machine_type = var.redis_instance_machine_type
  zone         = var.redis_instance_zone
  tags         = []

  allow_stopping_for_update = "false"

  boot_disk {
    source = google_compute_disk.redis_disk.self_link
  }

  metadata = {
//    ssh-keys = join("\n", var.ssh_keys
    startup-script = data.template_file.init_redis.rendered
  }

  network_interface {
    network = var.redis_instance_network
    network_ip = google_compute_address.redis_internal_address.address

    access_config {
      //ephemerial
    }
  }

}

resource "google_compute_disk" "redis_disk" {
  name    = "${var.redis_instance_name}-disk"
  project = var.project_id
  type    = var.redis_instance_disk_type
  size    = var.redis_instance_disk_size
  zone    = var.redis_instance_zone
  image   = var.redis_instance_image_type

  physical_block_size_bytes = 4096
}

resource "google_compute_address" "redis_internal_address" {
  name         = "${var.redis_instance_name}-internal-address"
  project      = var.project_id
  region       = var.redis_instance_region
  subnetwork   = var.redis_instance_subnetwork

  address_type = "INTERNAL"
}

data "template_file" "init_redis"{
  template = file("${path.module}/templates/init_redis.tpl")

  vars = {
    redis_port = var.redis_listen_port
  }
}

//resource "google_compute_address" "redis_external_address" {
//  count = "2"
//  name   = "elastic-public-ip-${count.index}"
//  region = var.region
//}

//resource "google_compute_firewall" "redis_allow_external" {
//  name    = "external-redis"
//  network = var.redis_instance_network
//
//  allow {
//    protocol = "tcp"
//    ports    = [var.redis_listen_port]
//  }
//  target_tags = ["redis-external"]
//}
