terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "github-actions-key"
  public_key = var.ssh_public_key
}

resource "digitalocean_droplet" "app" {
  image  = "ubuntu-22-04-x64"
  name   = "jlhr-app"
  region = var.region
  size   = var.size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  user_data = file("${path.module}/cloud-init.yml")
  tags = ["jlhr", "biogenio"]
}

output "droplet_ip" {
  value = digitalocean_droplet.app.ipv4_address
}