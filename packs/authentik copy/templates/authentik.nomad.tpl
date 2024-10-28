job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ .authentik.datacenters | toStringList ]]
  type = "service"

  group "app" {
    count = [[ .authentik.count ]]

    network {
      port "http" {
        to = 8000
      }
    }

    [[ if .authentik.register_consul_service ]]
    service {
      name = "[[ .authentik.consul_service_name ]]"
      tags = [[ .authentik.consul_service_tags | toStringList ]]
      port = "9000"

      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "20s"
        timeout  = "2s"
      }
    }
    [[ end ]]

    restart {
      attempts = 2
      interval = "10m"
      delay = "15s"
      mode = "fail"
    }

    task "server" {
      driver = "docker"

      config {
        image = "ghcr.io/goauthentik/server:2024.8.3"
        ports = ["9000"]
        command = "server"
      }

      env {
        AUTHENTIK_REDIS__HOST = [[.authentik.message | quote]]
        AUTHENTIK_POSTGRESQL__HOST = [[.authentik.message | quote]]
        AUTHENTIK_POSTGRESQL__USER = [[.authentik.message | quote]]
        AUTHENTIK_POSTGRESQL__NAME = [[.authentik.message | quote]]
        AUTHENTIK_POSTGRESQL__PASSWORD = [[.authentik.message | quote]]
      }
    }

    task "worker" {
      driver = "docker"

      config {
        image = "ghcr.io/goauthentik/server:2024.8.3"
        command = "worker"

      }

      env {
        AUTHENTIK_REDIS__HOST = [[.authentik.message | quote]]
        AUTHENTIK_POSTGRESQL__HOST = [[.authentik.message | quote]]
        AUTHENTIK_POSTGRESQL__USER = [[.authentik.message | quote]]
        AUTHENTIK_POSTGRESQL__NAME = [[.authentik.message | quote]]
        AUTHENTIK_POSTGRESQL__PASSWORD = [[.authentik.message | quote]]
      }
    }
  }
}
