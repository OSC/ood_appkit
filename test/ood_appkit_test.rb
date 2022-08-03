require 'test_helper'

class OodAppkitTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, OodAppkit
  end

  # FIXME: move these tests elsewhere
  #
  test "shell urls" do
    s = OodAppkit::Urls::Shell.new(base_url: "/sh")

    assert_equal "/sh/ssh/default", s.url.to_s
    assert_equal "/sh/ssh/oakley", s.url(host: "oakley").to_s
    assert_equal "/sh/ssh/oakley", s.url(host: :oakley).to_s
    assert_equal "/sh/ssh/oakley/nfs/gpfs", s.url(host: :oakley, path: "/nfs/gpfs").to_s
    assert_equal "/sh/ssh/default/nfs/gpfs", s.url(path: "/nfs/gpfs").to_s
    assert_equal "/sh/ssh/default/nfs/gpfs", s.url(path: Pathname.new("/nfs/gpfs")).to_s
  end

  test "files urls" do
    f = OodAppkit::Urls::Files.new(base_url: "/f")

    assert_equal "/f/fs/nfs/17/efranz/ood_dev", f.url(path: "/nfs/17/efranz/ood_dev").to_s
    assert_equal "/f/fs/nfs/17/efranz/ood_dev", f.url(path: Pathname.new("/nfs/17/efranz/ood_dev")).to_s

    assert_equal "/f/s3/mybucket/foo", f.url(path: "/mybucket/foo", fs: "s3").to_s
    assert_equal "/f/s3/mybucket/foo", f.url(path: Pathname.new("/mybucket/foo"), fs: "s3").to_s

    assert_equal "/f/api/v1/fs/foo/bar", f.api(path: "/foo/bar").to_s
    assert_equal "/f/api/v1/s3/foo/bar", f.api(path: "/foo/bar", fs: "s3").to_s

    assert_equal "/f/Remote%200.-_/foo/bar", f.url(path: "/foo/bar", fs: "Remote 0.-_").to_s
  end

  test "editor urls" do
    e = OodAppkit::Urls::Editor.new(base_url: "/f")

    assert_equal "/f/edit/fs/foo/bar", e.edit(path: "/foo/bar").to_s
    assert_equal "/f/edit/fs/foo/bar", e.edit(path: Pathname.new("/foo/bar")).to_s
    assert_equal "/f/edit/s3/foo/bar", e.edit(path: "/foo/bar", fs: "s3").to_s

    assert_equal "/f/edit/Remote%200.-_/foo/bar", e.edit(path: "/foo/bar", fs: "Remote 0.-_").to_s
  end
end
