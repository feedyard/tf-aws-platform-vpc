# frozen_string_literal: true

require 'awspec'
require 'json'

tfvars = JSON.parse(File.read('./' + ENV['PLATFORM_ENV'] + '.json'))

describe vpc(tfvars["cluster_vpc_name"]) do
  it { should exist }
  it { should be_available }
  it { should have_route_table(tfvars["cluster_vpc_name"] + '-rt-public') }
  it { should have_tag('pipeline').value('feedyard/tf-aws-platform-vpc') }
end

describe internet_gateway(tfvars["cluster_vpc_name"] + '-igw') do
  it { should exist }
  it { should be_attached_to(tfvars["cluster_vpc_name"]) }
  it { should have_tag('pipeline').value('feedyard/tf-aws-platform-vpc') }
end

tfvars["cluster_azs"].each do |az|
  describe subnet('subnet-' + tfvars["cluster_vpc_name"] + '-public-' + az) do
    it { should exist }
    it { should have_tag('pipeline').value('feedyard/tf-aws-platform-vpc') }
    it { should have_tag('Tier').value('public') }
    it { should have_tag('kubernetes.io/cluster/' + tfvars["cluster_name"]).value('shared') }
  end

  describe subnet('subnet-' + tfvars["cluster_vpc_name"] + '-nat-' + az) do
    it { should exist }
    it { should have_tag('pipeline').value('feedyard/tf-aws-platform-vpc') }
    it { should have_tag('Tier').value('nat') }
    it { should have_tag('kubernetes.io/cluster/' + tfvars["cluster_name"]).value('shared') }
    it { should have_tag('kubernetes.io/role/internal-elb').value('1') }
  end

  describe subnet('subnet-' + tfvars["cluster_vpc_name"] + '-internal-' + az) do
    it { should exist }
    it { should have_tag('pipeline').value('feedyard/tf-aws-platform-vpc') }
    it { should have_tag('Tier').value('internal') }
    it { should have_tag('kubernetes.io/cluster/' + tfvars["cluster_name"]).value('shared') }
  end

  describe route_table(tfvars["cluster_vpc_name"] + '-rt-public') do
    it { should exist }
    it { should have_subnet('subnet-' + tfvars["cluster_vpc_name"] + '-public-' + az) }
    it { should have_route('0.0.0.0/0').target(gateway: tfvars["cluster_vpc_name"] + '-igw') }
    it { should have_tag('pipeline').value('feedyard/tf-aws-platform-vpc') }
  end

  describe route_table(tfvars["cluster_vpc_name"] + '-rt-nat-' + az) do
    it { should exist }
    it { should have_subnet('subnet-' + tfvars["cluster_vpc_name"] + '-nat-' + az) }
    it { should have_tag('pipeline').value('feedyard/tf-aws-platform-vpc') }
  end

  describe route_table(tfvars["cluster_vpc_name"] + '-rt-internal-' + az) do
    it { should exist }
    it { should_not have_route('0.0.0.0/0') }
    it { should have_tag('pipeline').value('feedyard/tf-aws-platform-vpc') }
  end
end

