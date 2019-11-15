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

variable "project_id" {
  description = "The project ID to deploy to"
}

variable "redis_instance_name" {
  description = "Redis vm name"
  default = "redis"
}
variable "redis_instance_machine_type" {
  description = "Redis machine type"
  default = "n1-standard-1"
}
variable "redis_instance_zone" {
  description = "Redis default zone"
}
variable "redis_instance_network" {
  description = "Network for redis instance"
}

variable "redis_instance_disk_type" {
  description = "Redis disk type"
  default = "pd-standard"
}
variable "redis_instance_disk_size" {
  description = "Redis disk size in GB"
  default = 10
}
variable "redis_instance_image_type" {
  description = "Redis image type"
}

variable "redis_instance_region" {
  description = "Redis region"
}
variable "redis_instance_subnetwork" {
  description = "Subnetwork to use"
}

variable "redis_listen_port" {
  description = "Redis listen port"
  default = 6379
}