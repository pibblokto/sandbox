skip = true

dependency "node_pool_sa" {
    config_path = "../node_pool_sa"
    mock_outputs = {
        email = "mock-email@mock.sa"
    }
}