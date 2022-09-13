[all-ec2]
%{ for ip in aws_ec2_ip ~}
${ip}
%{ endfor ~}