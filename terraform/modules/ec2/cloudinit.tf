data "template_file" "shell-script" {
  template = file("${path.module}/scripts/concourse.sh")
}

data "template_cloudinit_config" "user-data" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script.rendered
  }
}