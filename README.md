Vivado Hooks
============

This repository contains a simple remote-build framework for Vivado projects, using
git's built-in "hooks" framework. Using this, you can trigger builds as
follows:

	$ git push -f some-machine:build HEAD:bitstream

or simulations as follows:

	$ git push -f some-machine:build HEAD:sim

...or anything else you can write in a bash script. If that's too much typing,
use:

	$ alias go_bitstream="git push -f some-machine:build HEAD:bitstream"
	$ alias go_sim="git push -f some-machine:build HEAD:sim"

and just run "go_bitstream" or "go_sim". When you do, the remote host kicks off
a bitstream build using your head-of-tree commit (HEAD) in

	some-machine:~/build/autobuild/[commit hash]-bitstream

...using the "hooks/bitstream" script that's hosted in the source repository.
Because it's version-controlled, it's allowed to co-evolve with the project.
(That means you can modify hooks without worrying about breaking older versions
of your tree.)

The build is hosted in a tmux session (named [commit hash]-bitstream), so it's
safe to close your laptop immediately and reconnect to the build later on.

Each build is hosted in its own git-worktree, making it addictively easy and
safe to launch several builds in parallel, up to the capacity of your build
machine to sustain them all. Because build trees are not overwritten or
deleted, you maintain a historical record of your builds. (Yes, this gets big,
but that's arguably a good use of disk space.)

Why?
----

Until you've tried this, you probably won't understand how confining your
current build process is, or how much it intrinsically conflicts with (or
sidesteps) your revison-control processes.

* Vivado's "remote build" infrastructure [1] relies on a fast shared
  filesystem, and is clearly intended for corporate LAN environments - this is
  certainly one type of office, but not the only type of office.

* Vivado via remote desktop (VNC/x11/etc) is brutal, especially over long
  distances or narrow pipes, and also requires a shared filesystem or remote
  copy of your build files.

* None of these approaches make it convenient to launch a clean, from-scratch
  build, and they all incentivize you to keep your build tree around long-term
  (which makes it likely that a clean check-out won't work, and keeps you from
  casually running multiple builds in parallel.)

* Running an on-prem or cloud-hosted CI/CD server means one more piece of
  infrastructure to manage, and pulls at least some build configuration out of
  your tree.

FAQ
---

Q: Do I need to commit every little change before I push it to the build server?
   I don't want millions of "corrected a typo" / "oops" commits in my git tree.

A: This is why "git rebase -i" exists - your local git history can be full of
   "fixme" commits, and you can force-push these to the build server without
   any problems. You should, however, rebase (squash, reorder, clarify) this
   tree before pushing it anywhere else.

Q: Is installing these hooks a security risk?

A: Well - yes, you are telling your build machine to run a modifiable script.
   Anyone who can push to the remote machine can run arbitrary code there.
   However, if you're using a ssh transport, that was probably already true.
   There is pretty good practical joke potential here.

Q: What if timing closure fails? How can I view the results without running
   into all the same problems (shared filesystems, copied directory trees, ...)

A: That's what .dcp files are for - use the build log to find the most recent
   .dcp file, and copy it from your build server to your local machine. Vivado
   lets you open these (open_checkpoint or via the GUI) without the rest of the
   project tree.

Setting Up
----------

Your build server requires Vivado and some additional packages (tmux, git).

1. On the build server, set up a bare repository endpoint that will receive
   your push triggers:

   some-machine$ git clone --bare git@github.com:myorg/myrepo.git build

2. On the build server, install the post-receive hook:

   some-machine$ cd build
   some-machine$ git show main:hooks/post-receive > hooks/post-receive
   some-machine$ chmod 755 hooks/post-receive

3. On your development machine, try it out:

   $ git push -f some-machine:build HEAD:bitstream

   ...or just "go_bitstream" if you set up the alias at the top. (Put this into
   the repository's setenv.sh script.)

[1]: https://docs.amd.com/r/en-US/ug904-vivado-implementation/Using-Remote-Hosts-and-Compute-Clusters
