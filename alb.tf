variable "php_lb_config" {
  type = object({
    ssl_policy = string
    desync_mitigation_mode = string
    health_check = object({
      grace_period = string
      type         = string
      path         = string
    })
  })
}

php_lb_config = {
  ssl_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  desync_mitigation_mode = "defensive"
  health_check = {
    grace_period = "300"
    type         = "ELB"
    path         = "/phpinfo.php"
  }
}
