# manage in node exporter
class nftables::rules::node_exporter(
  Optional[Variant[String,Array[String,1]]]
    $prometheus_server = undef,
  Integer
    $port = 9100,
) {
  if $prometheus_server {
    any2array($prometheus_server).each |$index,$prom| {

      nftables::rule{
        "default_in-node_exporter-${index}":
      }
      if $prom =~ /:/ {
        Nftables::Rule["default_in-node_exporter-${index}"]{
          content => "ip6 saddr ${prom} tcp dport ${port} accept",
        }
      } else {
        Nftables::Rule["default_in-node_exporter-${index}"]{
          content => "ip saddr ${prom} tcp dport ${port} accept",
        }
      }
    }
  } else {
    nftables::rule{
      'default_in-node_exporter':
        content => "tcp dport ${port} accept";
    }
  }
}
