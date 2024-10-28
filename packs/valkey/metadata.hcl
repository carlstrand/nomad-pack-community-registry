# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

app {
  url    = "https://github.com/valkey/valkey"
  author = "valkey"
}

pack {
  name        = "valkey"
  description = "valkey - Open-source, networked, in-memory, key-value data store -- STANDALONE INSTANCE"
  url         = "https://github.com/hashicorp/nomad-pack-community-registry/valkey"
  version     = "0.0.1"
}

integration {
  identifier = "nomad/hashicorp/valkey"
  name       = "valkey"
}
