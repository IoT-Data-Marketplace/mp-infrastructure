data "template_file" "worker_role" {
  template = file(format("%s/templates/worker-role.tmpl", path.module))

  vars = {
    worker_role_arn = var.eks_worker_iam_role_arn
  }
}

data "template_file" "additional_roles" {
  count    = length(var.eks_additional_access_roles)
  template = file(format("%s/templates/additional-roles.tmpl", path.module))

  vars = {
    role_arn = lookup(var.eks_additional_access_roles[count.index], "role_arn")
    username = lookup(var.eks_additional_access_roles[count.index], "username")
  }
}

data "template_file" "additional_users" {
  count    = length(var.eks_additional_user_access)
  template = file(format("%s/templates/additional-users.tmpl", path.module))

  vars = {
    user_arn = lookup(var.eks_additional_user_access[count.index], "user_arn")
    username = lookup(var.eks_additional_user_access[count.index], "username")
  }
}

resource "kubernetes_config_map" "aws_auth" {
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
