/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
locals {
  local_redis_metadata = {
    startup-script = data.template_file.init_redis.rendered

  }
}

data "template_file" "init_redis" {
  template = file("${path.module}/templates/init_redis.tpl")

  vars = {
    redis_port = var.redis_listen_port
  }
}

data "google_compute_subnetwork" "redis_subnetwork" {
  project = var.project_id
  name    = var.redis_instance_subnetwork
  region  = var.redis_instance_region
}

resource "null_resource" "wait_for_redis" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-redis.sh ${var.project_id} ${var.redis_instance_zone} ${var.redis_instance_name}"
  }

  depends_on = [google_compute_instance.vm_redis]
}

resource "google_compute_instance" "vm_redis" {
  name         = var.redis_instance_name
  project      = var.project_id
  machine_type = var.redis_instance_machine_type
  zone         = var.redis_instance_zone
  tags         = var.redis_instance_tags

  allow_stopping_for_update = "false"

  boot_disk {
    source = google_compute_disk.redis_disk.self_link
  }

  metadata = merge(
          local.local_redis_metadata,
           var.redis_metadata
  )


  network_interface {
    network = data.google_compute_subnetwork.redis_subnetwork.name
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
  subnetwork   = data.google_compute_subnetwork.redis_subnetwork.name

  address_type = "INTERNAL"
}
