terraform {
  required_providers {
    morpheus = {
      source  = "jouve/morpheus"
      version = "0.0.9"
    }
  }
}

provider "morpheus" {
  url          = "https://10.32.20.150"
  access_token = var.morpheus_access_token
}

variable "morpheus_access_token" {
  type = string
}

resource "morpheus_form" "main" {
  name        = "${var.prefix}VM ${var.name} 01"
  description = "Deploiement VM ${var.name}"
  code        = "${var.prefix}vm${var.instance_type_code}01"
  option_type {
    name        = "vm_name"
    field_name  = "c_name"
    field_label = "NOM VM"
    type        = "text"
    help_block  = "Nom de l'instance"
    required    = true
  }

  field_group {
    name = "ENVIRONNEMENT"
    option_type {
      name        = "mygroup"
      field_name  = "mygroup"
      field_label = "group"
      type        = "group"
      code        = "mygroup"
      required    = true
    }

    option_type {
      name        = "mycloud"
      field_name  = "mycloud"
      field_label = "Cloud"
      type        = "cloud"
      code        = "mycloud"
      group_code  = "mygroup"
      help_block  = "Choisir le Cloud Openstack ou Vmware qui hébergera la VM"
      required    = true
    }
  }

  field_group {
    name = "CONFIGURATION"
    option_type {
      name               = "templateconfig"
      field_name         = "mylayout"
      field_label        = "TEMPLATE DE CONFIGURATION"
      type               = "layout"
      help_block         = "Sélectionner un template pour renseigner les paramètres complémentaires (ex: version de l'OS)"
      group_code         = "mygroup"
      code               = "mylayout"
      cloud_code         = "mycloud"
      instance_type_code = var.instance_type_code
      required           = true
    }

    option_type {
      name        = "resourcepool"
      field_name  = "mypool4"
      field_label = "Resource Pool"
      type        = "resourcePool"
      code        = "mypool4"
      help_block  = "resource pool (RAM, CPU) à utiliser"
      group_code  = "mygroup"
      layout_code = "mylayout"
      cloud_code  = "mycloud"
      plan_code   = "myplan"
      hidden      = true
      required    = true
    }

    option_type {
      name        = "gabarit"
      field_name  = "myplan"
      field_label = "gabarit"
      type        = "plan"
      code        = "myplan"
      help_block  = "Gabarit compatible avec l'environnement sélectionné\n\nsmall ==> Cores: 1  Memory: 2 GB  \nmedium ==> Cores: 2  Memory: 4 GB  \nLarge ==> Cores: 2 Memory: 8 GB  \nxlarge ==> Cores: 4  Memory: 16 GB"
      group_code  = "mygroup"
      layout_code = "mylayout"
      cloud_code  = "mycloud"
      pool_code   = "mypool4"
      required    = true
    }

    option_type {
      name        = "labels"
      field_name  = "c_tags"
      field_label = "labels"
      type        = "tag"
      help_block  = "Labels additionnels pour marquer les VM"
      required    = true
    }
  }

  field_group {
    name = "EXPOSITION"
    option_type {
      name        = "reseau"
      field_name  = "c_networks"
      field_label = "reseaux"
      type        = "networkManager"
      help_block  = "Choisir le(s) réseau(x) qui sera interfacé à la VM"
      group_code  = "mygroup"
      layout_code = "mylayout"
      cloud_code  = "mycloud"
      pool_code   = "mypool4"
      required    = false
    }
  }
}

 

resource "morpheus_instance_catalog_item" "main" {
  name        = "${var.prefix}VM ${var.name} Openstack"
  description = "Déploiement d'une VM ${var.name} dans un environnement existant"
  enabled     = true
  featured    = true
  image_path  = "${path.module}/${var.instance_type_code}.svg"
  image_name  = "${path.module}/${var.instance_type_code}.svg"
  form_id     = morpheus_form.main.id
  config      = file("${path.module}/config-${var.instance_type_code}.json")
  visibility  = "public"
}

 
