# Cloudflare Recordsets Module

This module manages DNS recordsets in a Cloudflare DNS zone. It follows the structure of [the `terraformdns` project](https://terraformdns.github.io/).

# Example Usage

```hcl
locals {
  cloudflare_zone = "example.com"
}

module "dns_records" {
  source = "innovationnorway/dns-recordsets/cloudflare"

  zone_name = local.cloudflare_zone
  recordsets = [
    {
      name    = "www"
      type    = "A"
      ttl     = 3600
      records = [
        "192.0.2.56",
      ]
    },
    {
      name    = ""
      type    = "MX"
      ttl     = 3600
      records = [
        "1 mail1",
        "5 mail2",
        "5 mail3",
      ]
    },
    {
      name    = ""
      type    = "TXT"
      ttl     = 3600
      records = [
        "\"v=spf1 ip4:192.0.2.3 include:backoff.${local.cloudflare_zone} -all\"",
      ]
    },
    {
      name    = "_sip._tcp"
      type    = "SRV"
      ttl     = 3600
      records = [
        "10 60 5060 sip1",
        "10 20 5060 sip2",
        "10 20 5060 sip3",
        "20 0 5060 sip4",
      ]
    },
  ]
}
```

## Compatibility

When using this module, always use a version constraint that constraints to at
least a single major version. Future major versions may have new or different
required arguments, and may use a different internal structure that could
cause recordsets to be removed and replaced by the next plan.

## Arguments

- `zone_name` is the name of the Cloudflare zone to add the records to.
- `recordsets` is a list of DNS recordsets in the standard [`terraformdns`
  recordset format](https://terraformdns.github.io/about/).

This module requires the [`cloudflare`](https://www.terraform.io/docs/providers/cloudflare/index.html) provider.

Due to current limitations of the Terraform language, recordsets in Cloudflare
are correlated to `recordsets` elements using the index into the
`recordsets` list. Adding or removing records from the list will therefore
cause this module to also update all records with indices greater than where
the addition or removal was made.

## Limitations
As with all `terraformdns` modules, this module uses a generic, portable model of DNS recordsets and therefore it cannot make use of Cloudflare-specific features such as proxied DNS records etc.

If you need to use Cloudflare-specific features, use the [`cloudflare_record`](https://www.terraform.io/docs/providers/cloudflare/r/record.html) resource type directly.
