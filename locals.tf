locals {
  repo     = "${var.username}/${var.repo_name}"
  bot_name = replace(var.repo_name, "-", "_")
}
