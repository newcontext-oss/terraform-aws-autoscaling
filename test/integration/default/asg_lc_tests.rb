require 'awspec'

tf_state = JSON.parse(File.open('terraform.tfstate.d/kitchen-terraform-default-aws/terraform.tfstate').read)
region = tf_state['modules'][0]['outputs']['region']['value']
asg_name = tf_state['modules'][0]['outputs']['asg_name']['value']
lc_name = tf_state['modules'][0]['outputs']['lc_name']['value']
ENV['AWS_REGION'] = region

describe autoscaling_group("#{asg_name}") do
  it { should exist }
  it { should have_launch_configuration("#{lc_name}") }
  it { should have_tag('Environment').value('test') }
  it { should have_tag('Name').value('test-instance') }
  it { should have_ec2('test-instance') }
  its(:min_size) { should eq 0 }
  its(:max_size) { should eq 1 }
  its(:desired_capacity) { should eq 1 }
  its(:health_check_type) { should eq 'EC2' }
  its(:auto_scaling_group_name) { should match(/test-asg-/) }
end

describe launch_configuration("#{lc_name}") do
  it { should exist }
  it { should have_security_group('test-sg-https') }
  its(:image_id) { should eq 'ami-bf4193c7' }
  its(:instance_type) { should eq 't2.nano' }
  its(:launch_configuration_name) { should match(/test-lc-/) }
end
