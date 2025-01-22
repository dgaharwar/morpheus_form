terraform {
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.10.0"
    }
  }
}

provider "morpheus" {
  url      = var.morpheus_url
  username = var.morpheus_username
  password = var.morpheus_password
}

variable "morpheus_url" {
  description = "The URL of the Moprheus platform"
  type        = string
}

variable "morpheus_username" {
  description = "The username of the user account used to access the Morpheus platform"
  type        = string
}

variable "morpheus_password" {
  description = "The password of the user account used to access the Morpheus platform"
  type        = string
}

resource "morpheus_form" "tf_example_form" {
  name        = "demo"
  code        = "demo"
  description = "demo"
  labels      = ["terraform", "demo"]

  option_type {
    id = 2182
  }

  option_type {
    name                     = "test text"
    code                     = "test-input"
    description              = "Testing stuff"
    type                     = "text"
    field_label              = "Testin"
    field_name               = "test"
    default_value            = "Demo123"
    placeholder              = "Testing 123"
    help_block               = "Is this working now"
    required                 = true
    export_meta              = true
    display_value_on_details = true
    locked                   = false
    hidden                   = false
    exclude_from_search      = false
  }

}