provider "google" {
  credentials = file(var.credentials_path)
  project     = var.project_id
  region      = "us-central1"
}

# Define networking resources
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

# Create presentation tier resources
resource "google_compute_subnetwork" "presentation_subnet" {
  name          = "presentation-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_instance" "presentation_instance" {
  name         = "presentation-instance"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.presentation_subnet.id
  }
}

# Create application tier resources
resource "google_compute_subnetwork" "application_subnet" {
  name          = "application-subnet"
  ip_cidr_range = "10.0.2.0/24"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_instance" "application_instance" {
  name         = "application-instance"
  machine_type = "n1-standard-4"
  zone         = "us-central1-b"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.application_subnet.id
  }
}

# Create data tier resources
resource "google_compute_subnetwork" "data_subnet" {
  name          = "data-subnet"
  ip_cidr_range = "10.0.3.0/24"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_instance" "data_instance" {
  name         = "data-instance"
  machine_type = "n1-standard-8"
  zone         = "us-central1-c"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.data_subnet.id
  }
}
