require 'test_helper'
require 'ood_appkit/dotenv_rails'
require 'minitest/mock'

class OodAppkitTest < ActiveSupport::TestCase

  test "include_local_files argument affects dotenv_files loaded" do
    d = OodAppkit::DotenvRails.new
    assert_includes d.dotenv_files, d.root.join(".env.local")
    assert_includes d.dotenv_files, d.shared_dir.join("env")
    assert_includes d.dotenv_files, d.etc_dir.join("env")

    d = OodAppkit::DotenvRails.new(include_local_files: false)
    refute_includes d.dotenv_files, d.root.join(".env.local")
    refute_includes d.dotenv_files, d.shared_dir.join("env")
    refute_includes d.dotenv_files, d.etc_dir.join("env")
  end

  test "load normal dotenv files from specified dir" do
    Dir.mktmpdir do |dir|
      d = Pathname.new(dir)
      d.join('.env').write("FOO=1\nBAR=1")
      d.join('.env.local').write("BAR=2")
      d.join('.env.test.local').write("FOO=3\n")

      Bundler.with_clean_env do
        OodAppkit::DotenvRails.new(root_dir: d, include_local_files: false).load
        assert_equal '3', ENV['FOO'], ".env.test.local should have precedent over .env"
        assert_equal '1', ENV['BAR'], ".env.local should have been omitted so BAR value is 1 in .env"
      end

      Bundler.with_clean_env do
        OodAppkit::DotenvRails.new(root_dir: d, include_local_files: true).load
        assert_equal '3', ENV['FOO'], ".env.test.local should have precedent over .env"
        assert_equal '2', ENV['BAR'], ".env.local should have precendent over .env"
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

  test "verify Bundler.with_clean_env resets env after block completes" do
    assert_nil ENV['FOO']

    Bundler.with_clean_env do
      ENV['FOO'] = "bar"
      assert_equal "bar", ENV['FOO']
    end

    assert_nil ENV['FOO']
  end

  test "change paths to etc env and shared env parent directories" do
    Dir.mktmpdir do |dir|
      d = Pathname.new(dir).join("dashboard")
      d.mkdir

      Bundler.with_clean_env do
        ENV['OOD_CONFIG'] = '/etc/awesim/config'

        denv = OodAppkit::DotenvRails.new(root_dir: d)
        assert_equal '/etc/awesim/config/apps/dashboard', denv.etc_dir.to_s, "path should be configurable using OOD_CONFIG"
        assert_equal '/etc/awesim/config/shared', denv.shared_dir.to_s, "path should be configurable using OOD_CONFIG"
      end
    end
  end

  test "change paths to etc env and shared env parent directories using .env.config" do
    Dir.mktmpdir do |dir|
      d = Pathname.new(dir).join("dashboard")
      d.mkdir

      d.join(".env.config").write("OOD_CONFIG=/etc/awesim/config")

      Bundler.with_clean_env do
        denv = OodAppkit::DotenvRails.new(root_dir: d)
        denv.load
        assert_equal "/etc/awesim/config", ENV['OOD_CONFIG']
        assert_equal '/etc/awesim/config/apps/dashboard', denv.etc_dir.to_s, "path should be configurable using OOD_CONFIG"
        assert_equal '/etc/awesim/config/shared', denv.shared_dir.to_s, "path should be configurable using OOD_CONFIG"
      end
    end
  end

  test ".env.local overrides values set in etc config files" do
    Dir.mktmpdir do |dir|
      Bundler.with_clean_env do
        d = Pathname.new(dir).join('dashboard')
        d.mkpath
        ENV['OOD_CONFIG'] = d.join("config").to_s
        loader = OodAppkit::DotenvRails.new(root_dir: d, include_local_files: true)

        loader.etc_dir.mkpath
        loader.shared_dir.mkpath

        d.join('.env.local').write("FOO=SUCCESS\nBAR=SUCCESS")

        loader.etc_dir.join("env").write("BAR=FAIL")
        loader.shared_dir.join("env").write("FOO=FAIL")
        loader.load

        assert_equal 'SUCCESS', ENV['FOO'], ".env.local should have overridden this value set by shared config"
        assert_equal 'SUCCESS', ENV['BAR'], ".env.local should have overridden this value set by app config"
      end
    end
  end

  test "/etc config files override .env and .env.test" do
    Dir.mktmpdir do |dir|
      Bundler.with_clean_env do
        d = Pathname.new(dir).join('dashboard')
        d.mkpath
        ENV['OOD_CONFIG'] = d.join("config").to_s
        loader = OodAppkit::DotenvRails.new(root_dir: d, include_local_files: true)

        loader.etc_dir.mkpath
        loader.shared_dir.mkpath

        # app root dotenv files
        d.join('.env').write("FOO=FAIL")
        d.join('.env.test').write("BAR=FAIL")

        loader.etc_dir.join("env").write("FOO=SUCCESS")
        loader.shared_dir.join("env").write("BAR=SUCCESS")
        loader.load

        assert_equal 'SUCCESS', ENV['FOO'], "etc app config should have overridden this value"
        assert_equal 'SUCCESS', ENV['BAR'], "etc shared config should have overridden this value"
      end
    end
  end

  test "etc app config overrides etc shared config" do
    Dir.mktmpdir do |dir|
      Bundler.with_clean_env do
        d = Pathname.new(dir).join('dashboard')
        d.mkpath
        ENV['OOD_CONFIG'] = d.join("config").to_s
        loader = OodAppkit::DotenvRails.new(root_dir: d, include_local_files: true)

        loader.etc_dir.mkpath
        loader.shared_dir.mkpath

        loader.etc_dir.join("env").write("FOO=SUCCESS")
        loader.shared_dir.join("env").write("FOO=FAIL")
        loader.load

        assert_equal 'SUCCESS', ENV['FOO'], "etc app config should have overridden this value"
      end
    end
  end
end
