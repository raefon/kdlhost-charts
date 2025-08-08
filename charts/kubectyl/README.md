# Kubectyl Panel And Kuber Helm Chart

## Configuration

### Database Selection

Kubectyl supports either **MariaDB** (default, bundled chart) or an **external PostgreSQL** database for the Panel.  
You can specify which database to use via the `database.type` value in your `values.yaml`:

- `mariadb` (default): Uses the bundled MariaDB chart unless `mariadb.create` is set to `false`.
- `postgres`: Uses an external PostgreSQL instance. The bundled MariaDB chart will be disabled automatically if you set `database.type: postgres`.

The chart will automatically set the following Laravel environment variables:
- `DB_CONNECTION`: `mysql` for MariaDB, `pgsql` for Postgres.
- `SESSION_DRIVER`: `mysql` for MariaDB, `pgsql` for Postgres.

**Note:**  
- When using Postgres, you must provide connection details under the `postgres` section.
- The Postgres database is always external; there is no bundled Postgres chart.

---

### Global Values

| Key  | Type | Default | Description |
| :--: | :-----------------: | :-----: | ----------- |
| `global.timezone` | `string` | `UTC` | Timezone for the panel. |

---

### Ingress

| Key  | Type | Default | Description |
| :--: | :-----------------: | :-----: | ----------- |
| `ingress.class` | `string` | `nginx` | The Ingress class for routing external traffic to services. |
| `ingress.panel` | `string` | `panel.example.com` | The full FQDN that your panel will be accessible at. |
| `ingress.kuber` | `string` | `kuber.example.com` | The full FQDN that the kuber daemon will be accessible at. |
| `ingress.tls.create` | `bool` | `true` | Boolean to control if the chart should manage the creation of the Certificate resources. This is particularly useful if you have automation around Ingress resources that creates Certificates already. |
| `ingress.tls.clusterIssuer` | `string` | `letsencrypt-prod` | Name of the ClusterIssuer that should be specified on the Ingress resources to create your certificate. Required for most configurations even if not managing the certificate in this chart. |
| `ingress.annotations` | `map(string\|int\|bool)` | `{}` | Map of additional annotations to add to the Ingress resources. |

---

### Panel

| Key  | Type | Default | Description |
| :--: | :-----------------: | :-----: | ----------- |
| `panel.image` | `string` | `quay.io/kubectyl/panel:develop` | The image for the Panel application container. |
| `panel.storageClass` | `string` | `""` | The storage class to use for panel's persistent volume. To use default K8s storage class set this value to "". **This is mutually exclusive with `existingVolumeClaim` and should not be used with it.** |
| `panel.existingVolumeClaim` | `string` | `""` | Name of existing volume claim resource to use for the pod volumes. **This is mutually exclusive with `storageClass` and should not be used with it.** |
| `panel.email` | `string` | `abc@example.com` | The email address for Letsencrypt. Used for panel only as a reference to enable cert-manager. |
| `panel.serviceAnnotations` | `map(string\|int\|bool)` | `{}` | Map of additional annotations to add to the panel's Service resource. |
| `panel.statefulSetAnnotations` | `map(string\|int\|bool)` | `{}` | Map of additional annotations to add to the panel's StatefulSet resource. |

---

### Kuber

| Key  | Type | Default | Description |
| :--: | :-----------------: | :-----: | ----------- |
| `kuber.image` | `string` | `quay.io/kubectyl/kuber:develop` | The image for the Kuber application container. |
| `kuber.replicaCount` | `int` | `0` | Set to 0. Will be automatically set to 1 by panel after installation. |
| `kuber.serviceAnnotations` | `map(string\|int\|bool)` | `{}` | Map of additional annotations to add to kuber's Service resource. |
| `kuber.deploymentAnnotations` | `map(string\|int\|bool)` | `{}` | Map of additional annotations to add to kuber's Deployment resource. |

---

### Database Configuration

#### Database Type

| Key  | Type | Default | Description |
| :--: | :-----------------: | :-----: | ----------- |
| `database.type` | `string` | `mariadb` | Set to `mariadb` (default) or `postgres` to select the database backend. |

#### MariaDB

| Key  | Type | Default | Description |
| :--: | :-----------------: | :-----: | ----------- |
| `mariadb.create` | `bool` | `true` | Boolean to control creation of mariadb chart resources. Set to `false` if using Postgres. |
| `mariadb.global.storageClass` | `string` | `""` | The storage class to use for mariadb's persistent volume. |
| `mariadb.externalHost` | `string` | `""` | Hostname of external mariadb instance if you intend to use one. If using built-in mariadb chart, leave this blank or don't include it at all. |
| `mariadb.auth.database` | `string` | `panel` | Name of mariadb database to use for panel installation. |
| `mariadb.auth.username` | `string` | `kubectyl` | User to authenticate to mariadb with. |
| `mariadb.auth.password` | `string` | `SecretPassword` | Password for user `mariadb.auth.username`. |
| `mariadb.auth.rootPassword` | `string` | `SuperSecretPassword` | If creating host with chart, password to use for `root` user upon creation. |

#### External Postgres

| Key  | Type | Default | Description |
| :--: | :-----------------: | :-----: | ----------- |
| `postgres.externalHost` | `string` | `""` | Hostname of external Postgres instance. Required if `database.type` is `postgres`. |
| `postgres.auth.database` | `string` | `panel` | Name of Postgres database to use for panel installation. |
| `postgres.auth.username` | `string` | `kubectyl` | User to authenticate to Postgres with. |
| `postgres.auth.password` | `string` | `SecretPassword` | Password for user `postgres.auth.username`. |

---

### Redis

| Key  | Type | Default | Description |
| :--: | :-----------------: | :-----: | ----------- |
| `redis.create` | `bool` | `true` | Boolean to control creation of redis chart resources. Useful if you plan on using an external redis instance. |
| `redis.global.storageClass` | `string` | `""` | The storage class to use for the redis persistent volume. To use default K8s storage class set this value to "". |
| `redis.externalHost` | `string` | `""` | Hostname of external redis instance if you intend to use one. If using built-in redis chart, leave this blank or don't include it at all. |
| `redis.auth.enabled` | `bool` | `false` | Boolean to control whether we should try to authenticate when connecting to redis. |
| `redis.auth.password` | `string` | `""` | Password to use for redis authentication. |
| `redis.master.persistence.size` | `(int)Gi` | `1Gi` | The size of the master redis pod's persistent volume. |
| `redis.replica.replicaCount` | `int` | `0` | The number of redis replicas to create. |
| `redis.sentinel.enabled` | `bool` | `false` | Boolean to enable redis sentinel for high availability. |

---

### Service Account

| Key  | Type | Default | Description |
| :--: | :-----------------: | :-----: | ----------- |
| `serviceAccount.create` | `bool` | `true` | Boolean to enable the creation of a service account for our services. |
| `serviceAccount.name` | `string` | `""` | Name of service account to create. If not set, a name is generated. |

---

## Example values.yaml

```yaml
database:
  type: mariadb  # or "postgres"

mariadb:
  create: true   # Set to false if using Postgres
  externalHost: ""
  auth:
    username: kubectyl
    password: "your-mariadb-password"
    database: panel

postgres:
  externalHost: "your-postgres-host"
  auth:
    username: kubectyl
    password: "your-postgres-password"
    database: panel