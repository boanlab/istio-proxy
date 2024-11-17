#!/bin/bash

docker run \
    -e LD_DEBUG=libs,symbols,bindings \
    -e LD_DEBUG_OUTPUT=/tmp/ld-debug.log \
    -v $(pwd)/logs:/tmp \
    --entrypoint envoy \
    -p 9901:9901 -p 10000:10000 \
    -v $(pwd)/cert.pem:/etc/envoy/cert.pem \
    -v $(pwd)/key.pem:/etc/envoy/key.pem \
    boanlab/proxyv2:dyn_ld --config-yaml "
admin:
  address:
    socket_address:
      address: 0.0.0.0
      port_value: 9901
static_resources:
  listeners:
  - name: listener_0
    address:
      socket_address:
        address: 0.0.0.0
        port_value: 10000
    filter_chains:
    - transport_socket:
        name: envoy.transport_sockets.tls
        typed_config:
          '@type': type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.DownstreamTlsContext
          common_tls_context:
            tls_params:
              tls_minimum_protocol_version: TLSv1_2
              cipher_suites:
              - ECDHE-RSA-AES128-GCM-SHA256
              - ECDHE-RSA-AES256-GCM-SHA384
            tls_certificates:
              - certificate_chain: { filename: '/etc/envoy/cert.pem' }
                private_key: { filename: '/etc/envoy/key.pem' }
      filters:
      - name: envoy.filters.network.tcp_proxy
        typed_config:
          '@type': type.googleapis.com/envoy.extensions.filters.network.tcp_proxy.v3.TcpProxy
          stat_prefix: tcp
          cluster: service
  clusters:
  - name: service
    connect_timeout: 0.25s
    type: STATIC
    lb_policy: ROUND_ROBIN
    load_assignment:
      cluster_name: service
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              socket_address:
                address: 127.0.0.1
                port_value: 8080
"
