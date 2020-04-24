data "template_file" "worker_role" {
  depends_on = [module.eks_cluster]
  template   = file(format("%s/installation-dependencies/templates/worker-role.tmpl", path.module))

  vars = {
    worker_role_arn = module.eks_worker_iam.eks_worker_iam_role_arn
  }
}

data "template_file" "additional_roles" {
  depends_on = [module.eks_cluster]
  count      = length(var.eks_additional_access_roles)
  template   = file(format("%s/installation-dependencies/templates/additional-roles.tmpl", path.module))

  vars = {
    role_arn = lookup(var.eks_additional_access_roles[count.index], "role_arn")
    username = lookup(var.eks_additional_access_roles[count.index], "username")
  }
}

data "template_file" "additional_users" {
  depends_on = [module.eks_cluster]
  count      = length(local.eks_additional_user_access)
  template   = file(format("%s/installation-dependencies/templates/additional-users.tmpl", path.module))

  vars = {
    user_arn = lookup(local.eks_additional_user_access[count.index], "user_arn")
    username = lookup(local.eks_additional_user_access[count.index], "username")
  }
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [module.eks_cluster]
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = join("\n", concat(list(
      data.template_file.worker_role.rendered),
      data.template_file.additional_roles.*.rendered)
    )
    mapUsers = join("\n", data.template_file.additional_users.*.rendered)
  }
}
