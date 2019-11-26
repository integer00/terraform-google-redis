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


resource "tls_private_key" "fixture-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "fixture-private-key" {
  content = tls_private_key.fixture-key.private_key_pem
  filename = "${path.module}/ssh/key"
}

module "fixture-redis" {
  source = "../../../"

  project_id  = var.project_id
  redis_listen_port = var.redis_listen_port
  redis_instance_network = var.network
  redis_instance_subnetwork = var.subnetwork
  redis_instance_image_type = "centos-7"
  redis_instance_region = var.redis_instance_region
  redis_instance_zone = var.redis_instance_zone


  redis_metadata = {
    sshKeys = "ci:${tls_private_key.fixture-key.public_key_openssh}"
  }
}
