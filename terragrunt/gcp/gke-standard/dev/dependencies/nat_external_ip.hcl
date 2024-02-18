skip = true

dependency "nat_external_ip" {
    config_path = "../nat_external_ip"
    mock_outputs = {
        self_links = ["project/mock/resource/address/mock"]
        
    }
}