variable "instances" {
  description = "EC2 instances to create"

  type = map(object({
    ami                         = string
    instance_type               = string
    name                        = string
    subnet_id                   = string
    security_group_id           = string
    associate_public_ip_address = bool
    key_name                    = string

    root_block_device = object({
      volume_size           = number
      volume_type           = string
      iops                  = number
      throughput            = number
      encrypted             = bool
      delete_on_termination = bool
    })
  }))
}
