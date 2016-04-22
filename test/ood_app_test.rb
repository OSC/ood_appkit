require 'test_helper'

class OodAppTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, OodApp
  end

  # FIXME: move these tests elsewhere
  #
  test "shell urls" do
    s = OodApp::ShellApp.new("/sh")

    assert_equal "/sh/ssh/default", s.url
    assert_equal "/sh/ssh/oakley", s.url(host: "oakley")
    assert_equal "/sh/ssh/oakley", s.url(host: :oakley)
    assert_equal "/sh/ssh/oakley/nfs/gpfs", s.url(host: :oakley, path: "/nfs/gpfs")
    assert_equal "/sh/ssh/default/nfs/gpfs", s.url(path: "/nfs/gpfs")
    assert_equal "/sh/ssh/default/nfs/gpfs", s.url(path: Pathname.new("/nfs/gpfs"))
  end

  test "files urls" do
    f = OodApp::FilesApp.new("/f")
    assert_equal "/f/fs", f.base_fs_url
    assert_equal "/f/api/v1/fs", f.base_api_url

    assert_equal "/f/fs/nfs/17/efranz/ood_dev", f.url(path: "/nfs/17/efranz/ood_dev")
    assert_equal "/f/fs/nfs/17/efranz/ood_dev", f.url(path: Pathname.new("/nfs/17/efranz/ood_dev")
  end

end
