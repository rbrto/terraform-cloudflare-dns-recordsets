variable "zone_name" {
  type        = string
  description = "The name of the Cloudflare DNS zone to add records to."
}

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  description = "List of DNS record objects to manage, in the standard terraformdns structure."
}
