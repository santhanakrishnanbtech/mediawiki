output "public_ip" {
  value = aws_instance.this.*.public_ip
}

//data "template_file" "server_template" {
//  template = file("${path.module}/inventory.tpl")
//
//  vars = {
//    concourse_ip  = element(aws_instance.this.*.public_ip, count.index)
//  }
//}
//
//locals {
//  ansible_config_template_bastion = [
//    "",
//    "[concourse]",
//    data.template_file.server_template.*.rendered,
//  ]
//}
//
//output "inventory" {
//  value = replace(join("\n", local.ansible_config_template_bastion), "\n\n", "\n")
//}