terraform {
  required_version = "~> 0.12.6"
}

data "cloudflare_zones" "main" {
  filter {
    name = var.zone_name
  }
}

locals {
  recordsets = { for rs in var.recordsets : rs.type => rs... }

  a_recordsets     = lookup(local.recordsets, "A", [])
  aaaa_recordsets  = lookup(local.recordsets, "AAAA", [])
  cname_recordsets = lookup(local.recordsets, "CNAME", [])
  mx_recordsets    = lookup(local.recordsets, "MX", [])
  ns_recordsets    = lookup(local.recordsets, "NS", [])
  srv_recordsets   = lookup(local.recordsets, "SRV", [])
  txt_recordsets   = lookup(local.recordsets, "TXT", [])
  ptr_recordsets   = lookup(local.recordsets, "PTR", [])

  a_records = flatten([
    for rs in local.a_recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
  ])
  aaaa_records = flatten([
    for rs in local.aaaa_recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
  ])
  cname_records = flatten([
    for rs in local.cname_recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
  ])
  mx_records = flatten([
    for rs in local.mx_recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
  ])
  ns_records = flatten([
    for rs in local.ns_recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
  ])
  srv_records = flatten([
    for rs in local.srv_recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
  ])
  txt_records = flatten([
    for rs in local.txt_recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
  ])
  ptr_records = flatten([
    for rs in local.ptr_recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
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
  for_each = {
    for r in local.a_records : "${r.name} ${r.type} ${r.data}" => r
  }

  domain = var.zone_name

  name = coalesce(each.value.name, "@")

  type  = each.value.type
  ttl   = each.value.ttl
  value = each.value.data
}

resource "cloudflare_record" "aaaa" {
  for_each = {
    for r in local.aaaa_records : "${r.name} ${r.type} ${r.data}" => r
  }

  domain = var.zone_name

  name = coalesce(each.value.name, "@")

  type  = each.value.type
  ttl   = each.value.ttl
  value = each.value.data
}

resource "cloudflare_record" "cname" {
  for_each = {
    for r in local.cname_records : "${r.name} ${r.type} ${r.data}" => r
  }

  domain = var.zone_name

  name = coalesce(each.value.name, "@")

  type  = each.value.type
  ttl   = each.value.ttl
  value = each.value.data
}

resource "cloudflare_record" "mx" {
  for_each = {
    for r in local.mx_records : "${r.name} ${r.type} ${r.data}" => r
  }

  domain = var.zone_name

  name = coalesce(each.value.name, "@")

  type     = each.value.type
  ttl      = each.value.ttl
  priority = split(" ", each.value.data)[0]
  value    = split(" ", each.value.data)[1]
}

resource "cloudflare_record" "ns" {
  for_each = {
    for r in local.ns_records : "${r.name} ${r.type} ${r.data}" => r
  }

  domain = var.zone_name

  name = coalesce(each.value.name, "@")

  type  = each.value.type
  ttl   = each.value.ttl
  value = each.value.data
}

resource "cloudflare_record" "srv" {
  for_each = {
    for r in local.srv_records : "${r.name} ${r.type} ${r.data}" => r
  }

  domain = var.zone_name

  name = each.value.name
  type = each.value.type
  ttl  = each.value.ttl

  data = {
    service = split(".", each.value.name)[0]
    proto   = split(".", each.value.name)[1]

    priority = split(" ", each.value.data)[0]
    weight   = split(" ", each.value.data)[1]
    port     = split(" ", each.value.data)[2]
    target   = split(" ", each.value.data)[3]
  }
}

resource "cloudflare_record" "txt" {
  for_each = {
    for r in local.txt_records : "${r.name} ${r.type} ${r.data}" => r
  }

  domain = var.zone_name

  name = coalesce(each.value.name, "@")

  type  = each.value.type
  ttl   = each.value.ttl
  value = each.value.data
}

resource "cloudflare_record" "ptr" {
  for_each = {
    for r in local.ptr_records : "${r.name} ${r.type} ${r.data}" => r
  }

  domain = var.zone_name

  name = coalesce(each.value.name, "@")

  type  = each.value.type
  ttl   = each.value.ttl
  value = each.value.data
}
