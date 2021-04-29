aws_region = "ap-northeast-2"

iam_user_list = ["tom"]

image_id = "ami-064c81ce3a290fde1"
availability_zone_names = ["ap-northeast-2a","ap-northeast-2b","ap-northeast-2c"]
ami_id_maps = {
    ap-northeast-2 = {
      amazon_linux2 = "ami-010bf43fe22f847ed"
      ubuntu_18_04  = "ami-061b0ee20654981ab"
    }

    us-east-1 = {
      amazon_linux2 = "ami-0d29b48622869dfd9"
      ubuntu_18_04  = "ami-0d324124b7b7eec66"
    }
}
