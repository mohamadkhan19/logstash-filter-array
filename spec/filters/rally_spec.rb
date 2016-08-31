# encoding: utf-8
require 'spec_helper'
require "logstash/filters/example"

describe LogStash::Filters::Example do
  describe "Set to Hello World" do
    let(:config) do <<-CONFIG
      filter {
        rally {
          cusum_field => [fieldname]
        }
      }
    CONFIG
    end
  end
end
