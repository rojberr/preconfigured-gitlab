## Variable with our spec's - for DRY principle
variable "awsprops" {
  type = map(string)
  default = {
    region       = "eu-central-1"
    vpc          = "vpc-022dd99285b430a1e"
    ami          = "ami-0a5b5c0ea66ec560d"
    itype        = "t2.medium"
    subnet       = "subnet-08e8130112a9a72b1"
    publicip     = true
    keyname      = "preconfigured-gitlab-key"
    secgroupname = "preconfigured-gitlab-secgroup"
  }
}
