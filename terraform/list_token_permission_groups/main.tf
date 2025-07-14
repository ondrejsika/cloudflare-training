data "cloudflare_api_token_permission_groups_list" "permission_groups" {}

output "permission_groups" {
  value = join("\n", [
    for pg in data.cloudflare_api_token_permission_groups_list.permission_groups.result :
    join(" | ", [
      pg.id,
      {
        "com.cloudflare.api.account.zone" = "zone   "
        "com.cloudflare.api.account"      = "account"
        "com.cloudflare.edge.r2.bucket"   = "r2     "
        "com.cloudflare.api.user"         = "user   "
      }[pg.scopes[0]],
      pg.name,
    ])
  ])
}
