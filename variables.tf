variable "resource_group_name" {
  type    = string
  default = "rg-radio-lab"
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "acr_name" {
  type    = string
  default = "acrradiolab2025"   # doit être globalement unique
}

variable "aks_name" {
  type    = string
  default = "aks-radio-lab"
}