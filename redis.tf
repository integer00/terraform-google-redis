resource "google_compute_instance" "vm_redis" {
  name         = var.redis_instance_name
  machine_type = var.redis_instance_disk_type
  zone         = var.redis_instance_zone
  tags         = var.redis_instance_tags

  allow_stopping_for_update = "false"

  boot_disk {
    source = google_compute_disk.redis_disk.self_link
  }

//  metadata = {
//    ssh-keys = join("\n", var.ssh_keys)
//  }

  network_interface {
    subnetwork = var.redis_instance_subnetwork.self_link
    network_ip = google_compute_address.redis_internal_address.address

//    access_config {
//    }
  }

}

resource "google_compute_disk" "redis_disk" {
  name  = "${var.redis_instance_name}-disk"
  type  = var.redis_instance_disk_type
  size  = var.redis_instance_disk_size
  zone  = var.redis_instance_zone
  image = var.redis_instance_image_type

  physical_block_size_bytes = 4096
}

resource "google_compute_address" "redis_internal_address" {
  name   = "${var.redis_instance_name}-internal-address"
  region = var.redis_instance_region
  subnetwork = var.redis_instance_subnetwork

  address_type = "INTERNAL"
}

//resource "google_compute_address" "redis_external_address" {
//  count = "2"
//  name   = "elastic-public-ip-${count.index}"
//  region = var.region
//}

//resource "google_compute_firewall" "redis_allow_external" {
//  name    = "external-elastic"
//  network = google_compute_network.default.name
//
//  allow {
//    protocol = "tcp"
//    ports    = ["9200"]
//  }
//  target_tags = ["elastic-external"]
//}
