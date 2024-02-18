skip = true

dependency "network" {
    config_path = "../network"
    mock_outputs = {
        network_name = "mock-network-name"
        subnet_names = ["mock-subnet-name"]
    }
}