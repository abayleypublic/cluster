resource "random_password" "mysql_password" {
  length  = 32
  special = true
}

resource "oci_vault_secret" "mysql_password" {
  compartment_id = oci_identity_compartment.cluster.id
  key_id         = oci_kms_key.master_encryption_key.id
  secret_name    = "mysql_password"
  vault_id       = oci_kms_vault.secret_vault.id

  secret_content {
    content_type = "BASE64"
    content      = base64encode(random_password.mysql_password.result)
  }
}

resource "oci_mysql_mysql_db_system" "mysql_system" {
  availability_domain     = "CzwP:UK-LONDON-1-AD-3"
  compartment_id          = oci_identity_compartment.cluster.id
  shape_name              = "MySQL.Free"
  subnet_id               = oci_core_subnet.private_subnet.id
  access_mode             = "UNRESTRICTED"
  admin_username          = "mysql_admin"
  admin_password          = random_password.mysql_password.result
  configuration_id        = "ocid1.mysqlconfiguration.oc1..aaaaaaaa5a33g5cxy33cwd2egvmmyhnx5lsf5frueox3mgrnfqabdqdwio7a"
  crash_recovery          = "ENABLED"
  data_storage_size_in_gb = 50
  database_management     = "DISABLED"
  database_mode           = "READ_WRITE"
  description             = "Managed MySQL Database for k3s cluster. Mainly used as a backend for Temporal."
  display_name            = "mysql_server"
  fault_domain            = "FAULT-DOMAIN-3"
  hostname_label          = "mysql-server"
  is_highly_available     = false
  mysql_version           = "9.5.1"
  port                    = 3306
  port_x                  = 33060
  state                   = "ACTIVE"

  data_storage {
    is_auto_expand_storage_enabled = false
  }

  deletion_policy {
    automatic_backup_retention = "RETAIN"
    final_backup               = "SKIP_FINAL_BACKUP"
    is_delete_protected        = true
  }

  encrypt_data {
    key_generation_type = "SYSTEM"
  }

  maintenance {
    window_start_time = "FRIDAY 00:08"
  }

  rest {
    configuration = "DISABLED"
    port          = 443
  }

  secure_connections {
    certificate_generation_type = "SYSTEM"
  }
}
