# Yield - project management software
# Copyright (C) 2006-2014  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path('../../../test_helper', __FILE__)

class RoutingRepositoriesTest < ActionController::IntegrationTest
  def setup
    @path_hash  = repository_path_hash(%w[path to file.c])
    assert_equal "path/to/file.c", @path_hash[:path]
    assert_equal "path/to/file.c", @path_hash[:param]
  end

  def test_repositories_resources
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repositories/new" },
        { :controller => 'repositories', :action => 'new', :project_id => 'yield' }
      )
    assert_routing(
        { :method => 'post',
          :path => "/projects/yield/repositories" },
        { :controller => 'repositories', :action => 'create', :project_id => 'yield' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/repositories/1/edit" },
        { :controller => 'repositories', :action => 'edit', :id => '1' }
      )
    assert_routing(
        { :method => 'put',
          :path => "/repositories/1" },
        { :controller => 'repositories', :action => 'update', :id => '1' }
      )
    assert_routing(
        { :method => 'delete',
          :path => "/repositories/1" },
        { :controller => 'repositories', :action => 'destroy', :id => '1' }
      )
    ["get", "post"].each do |method|
      assert_routing(
          { :method => method,
            :path => "/repositories/1/committers" },
          { :controller => 'repositories', :action => 'committers', :id => '1' }
        )
    end
  end

  def test_repositories_show
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository" },
        { :controller => 'repositories', :action => 'show', :id => 'yield' }
      )
  end

  def test_repositories
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/statistics" },
        { :controller => 'repositories', :action => 'stats', :id => 'yield' }
     )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/graph" },
        { :controller => 'repositories', :action => 'graph', :id => 'yield' }
     )
  end

  def test_repositories_show_with_repository_id
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo" },
        { :controller => 'repositories', :action => 'show', :id => 'yield', :repository_id => 'foo' }
      )
  end

  def test_repositories_with_repository_id
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/statistics" },
        { :controller => 'repositories', :action => 'stats', :id => 'yield', :repository_id => 'foo' }
     )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/graph" },
        { :controller => 'repositories', :action => 'graph', :id => 'yield', :repository_id => 'foo' }
     )
  end

  def test_repositories_revisions
    empty_path_param = []
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions" },
        { :controller => 'repositories', :action => 'revisions', :id => 'yield' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions.atom" },
        { :controller => 'repositories', :action => 'revisions', :id => 'yield',
          :format => 'atom' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2457" },
        { :controller => 'repositories', :action => 'revision', :id => 'yield',
          :rev => '2457' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2457/show" },
        { :controller => 'repositories', :action => 'show', :id => 'yield',
          :rev => '2457' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2457/show/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'show', :id => 'yield',
          :path => @path_hash[:param] , :rev => '2457'}
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2457/diff" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield',
          :rev => '2457' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2457/diff" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield',
          :rev => '2457', :format => 'diff' },
        {},
        { :format => 'diff' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2/diff/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield',
          :path => @path_hash[:param], :rev => '2' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2/diff/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield',
          :path => @path_hash[:param], :rev => '2', :format => 'diff' },
        {},
        { :format => 'diff' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2/entry/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'entry', :id => 'yield',
          :path => @path_hash[:param], :rev => '2' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2/raw/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'raw', :id => 'yield',
          :path => @path_hash[:param], :rev => '2' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revisions/2/annotate/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'annotate', :id => 'yield',
          :path => @path_hash[:param], :rev => '2' }
      )
  end

  def test_repositories_revisions_with_repository_id
    empty_path_param = []
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions" },
        { :controller => 'repositories', :action => 'revisions', :id => 'yield', :repository_id => 'foo' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions.atom" },
        { :controller => 'repositories', :action => 'revisions', :id => 'yield', :repository_id => 'foo',
          :format => 'atom' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2457" },
        { :controller => 'repositories', :action => 'revision', :id => 'yield', :repository_id => 'foo',
          :rev => '2457' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2457/show" },
        { :controller => 'repositories', :action => 'show', :id => 'yield', :repository_id => 'foo',
          :rev => '2457' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2457/show/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'show', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param] , :rev => '2457'}
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2457/diff" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield', :repository_id => 'foo',
          :rev => '2457' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2457/diff" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield', :repository_id => 'foo',
          :rev => '2457', :format => 'diff' },
        {},
        { :format => 'diff' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2/diff/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param], :rev => '2' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2/diff/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param], :rev => '2', :format => 'diff' },
        {},
        { :format => 'diff' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2/entry/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'entry', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param], :rev => '2' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2/raw/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'raw', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param], :rev => '2' }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revisions/2/annotate/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'annotate', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param], :rev => '2' }
      )
  end

  def test_repositories_non_revisions_path
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/changes" },
        { :controller => 'repositories', :action => 'changes', :id => 'yield' }
      )
    ['2457', 'master', 'slash/slash'].each do |rev|
      assert_routing(
           { :method => 'get',
             :path => "/projects/yield/repository/changes" },
           { :controller => 'repositories', :action => 'changes', :id => 'yield',
             :rev => rev },
           {},
           { :rev => rev }
         )
    end
    ['2457', 'master', 'slash/slash'].each do |rev|
      assert_routing(
           { :method => 'get',
             :path => "/projects/yield/repository/changes/#{@path_hash[:path]}" },
           { :controller => 'repositories', :action => 'changes', :id => 'yield',
             :path => @path_hash[:param], :rev => rev },
           {},
           { :rev => rev }
         )
    end
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/diff/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/browse/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'browse', :id => 'yield',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/entry/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'entry', :id => 'yield',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/raw/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'raw', :id => 'yield',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/annotate/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'annotate', :id => 'yield',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/changes/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'changes', :id => 'yield',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/revision" },
        { :controller => 'repositories', :action => 'revision', :id => 'yield' }
      )
  end

  def test_repositories_non_revisions_path_with_repository_id
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/changes" },
        { :controller => 'repositories', :action => 'changes',
          :id => 'yield', :repository_id => 'foo' }
      )
    ['2457', 'master', 'slash/slash'].each do |rev|
      assert_routing(
           { :method => 'get',
             :path => "/projects/yield/repository/foo/changes" },
           { :controller => 'repositories', :action => 'changes',
             :id => 'yield',
             :repository_id => 'foo', :rev => rev },
           {},
           { :rev => rev }
         )
    end
    ['2457', 'master', 'slash/slash'].each do |rev|
      assert_routing(
           { :method => 'get',
             :path => "/projects/yield/repository/foo/changes/#{@path_hash[:path]}" },
           { :controller => 'repositories', :action => 'changes', :id => 'yield',
             :repository_id => 'foo', :path => @path_hash[:param], :rev => rev },
           {},
           { :rev => rev }
         )
    end
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/diff/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'diff', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/browse/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'browse', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/entry/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'entry', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/raw/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'raw', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/annotate/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'annotate', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/changes/#{@path_hash[:path]}" },
        { :controller => 'repositories', :action => 'changes', :id => 'yield', :repository_id => 'foo',
          :path => @path_hash[:param] }
      )
    assert_routing(
        { :method => 'get',
          :path => "/projects/yield/repository/foo/revision" },
        { :controller => 'repositories', :action => 'revision', :id => 'yield', :repository_id => 'foo'}
      )
  end

  def test_repositories_related_issues
    assert_routing(
        { :method => 'post',
          :path => "/projects/yield/repository/revisions/123/issues" },
        { :controller => 'repositories', :action => 'add_related_issue',
          :id => 'yield', :rev => '123' }
      )
    assert_routing(
        { :method => 'delete',
          :path => "/projects/yield/repository/revisions/123/issues/25" },
        { :controller => 'repositories', :action => 'remove_related_issue',
          :id => 'yield', :rev => '123', :issue_id => '25' }
      )
  end

  def test_repositories_related_issues_with_repository_id
    assert_routing(
        { :method => 'post',
          :path => "/projects/yield/repository/foo/revisions/123/issues" },
        { :controller => 'repositories', :action => 'add_related_issue',
          :id => 'yield', :repository_id => 'foo', :rev => '123' }
      )
    assert_routing(
        { :method => 'delete',
          :path => "/projects/yield/repository/foo/revisions/123/issues/25" },
        { :controller => 'repositories', :action => 'remove_related_issue',
          :id => 'yield', :repository_id => 'foo', :rev => '123', :issue_id => '25' }
      )
  end
end
