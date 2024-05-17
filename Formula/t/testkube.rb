class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.36.tar.gz"
  sha256 "5ddfdb330ea59e0638160370a775f4db763882efb34dedf1e6bb46210a1cd7d9"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1430469070875ddefcf155574dadfe32aa9f44790a0b7c888c1ee368802021b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c591ea82f5ff57d6730235586cd090f66a65c2938c7c3c033f01525cf0a45c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "804cbc2c7a5d1b07bd4e3a3b8f51851bf455b48bab2aeeca2d1f25ffc17701a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1d9121c97388acba28ca9ec091d90216faee8c2a3260f85d7ebfb9ec4875e1a"
    sha256 cellar: :any_skip_relocation, ventura:        "7361a74b728f77b298ecb9874d83a98b38749f4edd855f5ac95a6a12a8dc6265"
    sha256 cellar: :any_skip_relocation, monterey:       "1faef18a30debdf94cf61ac9feabb98b9eed4a34b7c54edeb303c522caa349ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b204e09a15ec7789c8fae90d8a1d319855a6e4de8edf82fdecedc02fff8a09c0"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags:),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
