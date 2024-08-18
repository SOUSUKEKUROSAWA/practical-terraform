# ---------------------------------------------------------------------
# DB接続情報
# Apply時は仮値で作成されるので, Apply後に手動で適切な値に更新すること
# ---------------------------------------------------------------------

module "db_username" {
  source      = "../../modules/parameter-store"
  name        = "/db/username"
  description = "DBのユーザー名"
  is_secure   = false
}

module "db_password" {
  source      = "../../modules/parameter-store"
  name        = "/db/password"
  description = "DBのパスワード"
  is_secure   = true
}
