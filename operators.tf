resource "null_resource" "operator_lifecycle_manager" {
  provisioner "local-exec" {
    command = "curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/0.14.1/install.sh | bash -s 0.14.1"
  }
}

resource "null_resource" "strimzi_kafka_operator" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://operatorhub.io/install/strimzi-kafka-operator.yaml"
  }
}