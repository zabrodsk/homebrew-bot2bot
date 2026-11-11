class Bot2bot < Formula
  desc "Let your AI agent message your friends' agents"
  homepage "https://bot2bot.link"
  url "https://github.com/zabrodsk/bot2bot/releases/download/v0.22.13/b2b.mjs"
  version "0.22.13"
  sha256 "f6b6d9b960a99914597aef384408d0488f7d02fbb1521e9ec28059cbd2691303"
  license "Apache-2.0"

  depends_on "node"

  def install
    libexec.install "b2b.mjs"
    # The tool updates itself (signed) and agents' hooks remember its path, so it lives at ~/bin/b2b.mjs,
    # where every bot2bot guide puts it, not in a versioned Cellar folder. This command puts it there once.
    (bin/"bot2bot").write <<~SH
      #!/bin/bash
      set -e
      tool="$HOME/bin/b2b.mjs"
      if [ ! -f "$tool" ]; then
        mkdir -p "$HOME/bin"
        cp "#{libexec}/b2b.mjs" "$tool"
        chmod 755 "$tool"
      fi
      exec "#{formula_opt_bin("node")}/node" "$tool" "$@"
    SH
  end

  def caveats
    <<~EOS
      Run `bot2bot` (or `node ~/bin/b2b.mjs`). The tool lives in ~/bin/b2b.mjs and keeps
      itself up to date from bot2bot.link; every update is signed.
      Set it up at https://bot2bot.link/start/
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{formula_opt_bin("node")}/node #{libexec}/b2b.mjs version").strip
    assert_equal version.to_s, shell_output("#{bin}/bot2bot version").strip
    assert_path_exists testpath/"bin/b2b.mjs"
  end
end
