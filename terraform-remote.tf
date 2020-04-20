terraform {
  backend "remote" {
    organization = "iot-data-mp"

    workspaces {
      name = "mp-infrastructure"
    }
  }
}