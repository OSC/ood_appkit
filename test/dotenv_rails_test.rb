require 'test_helper'
require 'ood_appkit/dotenv_rails'
require 'minitest/mock'

class OodAppkitTest < ActiveSupport::TestCase
  test "load normal dotenv files from specified dir" do
    Dir.mktmpdir do |dir|
      d = Pathname.new(dir)
      d.join('.env').write("FOO=1\nBAR=1")
      d.join('.env.test').write("FOO=2\nBAR=2\n")
      d.join('.env.local').write("FOO=3\n")

      Bundler.with_clean_env do
        Rails.env.stub :test?, false do
          OodAppkit::DotenvRails.new(root_dir: d).load
          assert_equal '3', ENV['FOO']
          assert_equal '2', ENV['BAR']
        end
      end
    end
  end

  test "etc env and shared env parent directory have correct defaults" do
    Dir.mktmpdir do |dir|
      d = Pathname.new(dir).join("dashboard")
      d.mkdir

      denv = OodAppkit::DotenvRails.new(root_dir: d)
      assert_equal '/etc/ood/config/apps/dashboard', denv.etc_dir.to_s
      assert_equal '/etc/ood/config/shared', denv.shared_dir.to_s
    end
  end

  # test: set ability to change locations of etc/app/env and etc/shared/env in dotenv.config
  # test: set env in app/env and etc/app/env => etc/app/env is used (verify etc/app/env overrides everything that is not .local)
  # test: set env in app/env.local and etc/app/env and etc/shared/env => app/env.local is used (verify .env.local overrides all)

  # test "etc env and shared env modify env" do
  #   Dir.mktmpdir do |dir|
  #     d = Pathname.new(dir).join('dashboard')
  #     d.mkdir

  #     d.join('.env').write('FOO=1\nBAR=1\nETC=0\nSHARED=0\nSHARED_OVERRIDE=0')
  #     d.join('.env.test').write('FOO=2\nBAR=2')
  #     d.join('.env.local').write('FOO=3')

  #     etc = d.join('etc', 'config', 'apps', 'dashboard')
  #     etc.mkpath
  #     etc.join("env").write('ETC=1\nSHARED_OVERRIDE=1')

  #     shared = d.join('shared')
  #     shared.mkpath
  #     shared.join("env").write('SHARED=1\nSHARED_OVERRIDE=2')

  #     Bundler.with_clean_env do
  #       OodAppkit::DotenvRails.new(root_dir: d, etc_dir: etc, shared_dir: shared).load
  #       assert_equal '3', ENV['FOO']
  #       assert_equal '2', ENV['BAR']
  #       assert_equal '1', ENV['ETC']
  #       assert_equal '1', ENV['SHARED_OVERRIDE'], "etc/config/apps/dashboard/env's SHARED_OVERRIDE value should have precedence over shared env"
  #     end
  #   end
  # end

end
