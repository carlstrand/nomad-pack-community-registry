# valkey -- Standalone Instance

This pack runs [valkey](https://valkey.io) as a standalone instance using the Nomad [service](https://www.nomadproject.io/docs/schedulers#service) scheduler. The service runs as a Docker container using the [Docker](https://www.nomadproject.io/docs/drivers/docker) driver.

Note: This is a standalone instance of valkey.

Default (Vanilla) Installation:
- [Protected Mode](https://valkey.io/topics/security#protected-mode) is disabled by default.
- No volumes are attached. All data are stored in the container's `/data` directory. To learn more about persisted storage, see [Persisting Storage](#persisting-storage) below.
- The container uses the default valkey configuration as specified [here](https://registry.hub.docker.com/_/valkey).
- By default, a snapshot is automatically created as `/data/dump.rdb` when the following are true:
  - After 3600 seconds (an hour) if at least 1 key changed
  - After 300 seconds (5 minutes) if at least 100 keys changed
  - After 60 seconds if at least 10000 keys changed

---
## Available Variables
`app_count` (number) - Number of instances to deploy

`consul_service_name` (string) - Name used by Consul, if registering the job in Consul

`consul_service_port` (string) - Port used by Consul, if registering the job in Consul

`consul_tags` (list of string) - Tags to use for job

`datacenters` (list of string) - Datacenters this job will be deployed

`has_health_check` (bool) - If Consul should use a health check -- Port needs to be exposed.

`health_check` (object) - Consul health check details

`image` (string) - valkey Docker image.

`job_name` (string) - Name of the Nomad job -- Overrides the default pack name

`network` (list of object) - Job network specifications

`valkey_volume` (string) - The volume name defined in the Nomad agent configuration

`region` (string) - Region where the job should be placed.

`register_consul_service` (bool) - Register this job in Consul

`resources` (object) - Resources to assign this job

`restart_attempts` (number) - Number of attempts to restart the job due to updates, failures, etc

`update` (object) - Job update parameters

`use_host_volume` (bool) - Use a host volume as defined in the Nomad client configuration


---
## Persisting Storage

In most production cases, you will need to deploy valkey while using persisted storage for data backup and restoration. Additionally, you may also want to deploy valkey using your own configuration file.

### Using Host Volume
If you wish to utilize Nomad's host volume for valkey data, you must have the following in place:

1. The directory that will be used exists on the Nomad host(s)
2. The host volume block is added in the Nomad client configuration, as specified [here](https://learn.hashicorp.com/tutorials/nomad/stateful-workloads-host-volumes#configure-the-client)
```hcl
client {
  host_volume "valkey" {
    path      = "/path/to/volume"
    read_only = false
  }
}
```

3. The `use_host_volume` variable is set to `true`
```
--var use_host_volume=true
```

4. (Optional) The name of the volume is set using the `valkey_volume` variable. Default is `valkey`
```
--var valkey_volume=<volume name>
```

Nomad will mount the host volume into the default `/data` directory within the container.

---
## Example Usage
```
nomad-pack run valkey --var job_name="valkey-standalone" --var use_host_volume=true --var image="valkey:6.2.6"
```
