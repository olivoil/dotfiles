#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# AUTHOR:
# Ben Hoskings            https://github.com/benhoskings/dot-files/blob/master/files/bin/git_cwd_info
# MODIFIED:
# Geoffrey Grosenbach     http://peepcode.com
# Olivier Melcher         http://twitter.com/oliv_oil

# The methods that get called more than once are memoized.

def git_repo_path
  @git_repo_path ||= `git rev-parse --git-dir 2>/dev/null`.strip
end

def in_git_repo
  !git_repo_path.empty? &&
    git_repo_path != '~' &&
    git_repo_path != "#{ENV['HOME']}/.git"
end

def git_current_branch
end

def git_parse_branch
  @git_parse_branch ||= `git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||'`.chomp
end

def git_head_commit_id
  `git rev-parse --short HEAD 2>/dev/null`.strip
end

def git_cwd_dirty
  " %{\e[90m%}✗%{\e[0m%}" unless git_repo_path == '.' || `git ls-files -m`.strip.empty?
end

def git_cwd_untracked
  " %{\e[90m%}?%{\e[0m%}" unless git_repo_path == '.' || `git ls-files --others --exclude-standard`.strip.empty?
end

def git_cwd_staged
  " %{\e[90m%}+%{\e[0m%}" unless git_repo_path == '.' || `git diff --cached 2>/dev/null`.strip.empty?
end

def rebasing_etc
  if File.exists?(File.join(git_repo_path, 'BISECT_LOG'))
    "+bisect"
  elsif File.exists?(File.join(git_repo_path, 'MERGE_HEAD'))
    "+merge"
  elsif %w[rebase rebase-apply rebase-merge ../.dotest].any? {|d| File.exists?(File.join(git_repo_path, d)) }
    "+rebase"
  end
end

def separator
  "%{\e[37m%}#{ARGV[0]} %{\e[0m%}"
end

if in_git_repo
  print "#{separator}%{\e[90m%}#{git_parse_branch} %{\e[37m%}#{git_head_commit_id}%{\e[0m%}#{rebasing_etc}#{git_cwd_dirty}#{git_cwd_untracked}#{git_cwd_staged}"
end
