skip = true

dependency "network" {
    config_path = "../network"
    mock_outputs = {
        network_name = "mock-network-name"
        subnets_names = ["mock-subnet-name"]
    }
}