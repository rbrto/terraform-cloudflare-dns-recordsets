terraform {
  required_version = ">= 0.12.0"
}

data "cloudflare_zones" "main" {
  filter {
    name = var.zone_name
  }
}

locals {
  recordsets = { for rs in var.recordsets : rs.type => rs ... }

  a_recordsets     = lookup(local.recordsets, "A", [])
  aaaa_recordsets  = lookup(local.recordsets, "AAAA", [])
  cname_recordsets = lookup(local.recordsets, "CNAME", [])
  mx_recordsets    = lookup(local.recordsets, "MX", [])
  ns_recordsets    = lookup(local.recordsets, "NS", [])
  srv_recordsets   = lookup(local.recordsets, "SRV", [])
  txt_recordsets   = lookup(local.recordsets, "TXT", [])
  ptr_recordsets   = lookup(local.recordsets, "PTR", [])

  a_records = flatten([
    for rs in local.a_recordsets : flatten([
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ])
  ])
  aaaa_records = flatten([
    for rs in local.aaaa_recordsets : flatten([
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ])
  ])
  cname_records = flatten([
    for rs in local.cname_recordsets : flatten([
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ])
  ])
  mx_records = flatten([
    for rs in local.mx_recordsets : flatten([
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ])
  ])
  ns_records = flatten([
    for rs in local.ns_recordsets : flatten([
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ])
  ])
  srv_records = flatten([
    for rs in local.srv_recordsets : flatten([
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ])
  ])
  txt_records = flatten([
    for rs in local.txt_recordsets : flatten([
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ])
  ])
  ptr_records = flatten([
    for rs in local.ptr_recordsets : flatten([
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ])
  ])

  supported_record_types = {
    A     = true
    AAAA  = true
    CNAME = true
    MX    = true
    NS    = true
    SRV   = true
    TXT   = true
    PTR   = true
  }

  check_supported_types = [
    for rs in var.recordsets : local.supported_record_types[rs.type]
  ]
}

resource "cloudflare_record" "a" {
  count = length(local.a_records)

  domain = var.zone_name

  name = local.a_records[count.index].name != "" ? local.a_records[count.index].name : "@"

  type  = local.a_records[count.index].type
  ttl   = local.a_records[count.index].ttl
  value = local.a_records[count.index].data
}

resource "cloudflare_record" "aaaa" {
  count = length(local.aaaa_records)

  domain = var.zone_name

  name = local.aaaa_records[count.index].name != "" ? local.aaaa_records[count.index].name : "@"

  type  = local.aaaa_records[count.index].type
  ttl   = local.aaaa_records[count.index].ttl
  value = local.aaaa_records[count.index].data
}

resource "cloudflare_record" "cname" {
  count = length(local.cname_records)

  domain = var.zone_name

  name = local.cname_records[count.index].name != "" ? local.cname_records[count.index].name : "@"

  type  = local.cname_records[count.index].type
  ttl   = local.cname_records[count.index].ttl
  value = local.cname_records[count.index].data
}

resource "cloudflare_record" "mx" {
  count = length(local.mx_records)

  domain = var.zone_name

  name = local.mx_records[count.index].name != "" ? local.mx_records[count.index].name : "@"

  type     = local.mx_records[count.index].type
  ttl      = local.mx_records[count.index].ttl
  priority = split(" ", local.mx_records[count.index].data)[0]
  value    = split(" ", local.mx_records[count.index].data)[1]
}

resource "cloudflare_record" "ns" {
  count = length(local.ns_records)

  domain = var.zone_name

  name = local.ns_records[count.index].name != "" ? local.ns_records[count.index].name : "@"

  type  = local.ns_records[count.index].type
  ttl   = local.ns_records[count.index].ttl
  value = local.ns_records[count.index].data
}

resource "cloudflare_record" "srv" {
  count = length(local.srv_records)

  domain = var.zone_name

  name = local.srv_records[count.index].name

  type = local.srv_records[count.index].type
  ttl  = local.srv_records[count.index].ttl

  data = {
    service = split(".", local.srv_records[count.index].name)[0]
    proto   = split(".", local.srv_records[count.index].name)[1]

    priority = split(" ", local.srv_records[count.index].data)[0]
    weight   = split(" ", local.srv_records[count.index].data)[1]
    port     = split(" ", local.srv_records[count.index].data)[2]
    target   = split(" ", local.srv_records[count.index].data)[3]
  }
}

resource "cloudflare_record" "txt" {
  count = length(local.txt_records)

  domain = var.zone_name

  name = local.txt_records[count.index].name != "" ? local.txt_records[count.index].name : "@"

  type  = local.txt_records[count.index].type
  ttl   = local.txt_records[count.index].ttl
  value = local.txt_records[count.index].data
}

resource "cloudflare_record" "ptr" {
  count = length(local.ptr_records)

  domain = var.zone_name

  name = local.ptr_records[count.index].name != "" ? local.ptr_records[count.index].name : "@"

  type  = local.ptr_records[count.index].type
  ttl   = local.ptr_records[count.index].ttl
  value = local.ptr_records[count.index].data
}
