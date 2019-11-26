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
output "project_id" {
  description = "The ID of the project in which resources are provisioned."
  value       = var.project_id
}

output "redis_port" {
  value = module.redis-example.redis_instance_port
}

output "redis_zone" {
  value = module.redis-example.redis_instance_zone
}

output "redis_name" {
  value = module.redis-example.redis_instance_name
}

output "redis_instance_public_ip" {
  value = module.redis-example.redis_instance_public_ip
}

