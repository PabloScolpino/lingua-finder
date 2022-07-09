# frozen_string_literal: true

class Parser
  base_path = __dir__
  require File.join(base_path, 'node_extensions.rb')
  Treetop.load(File.join(base_path, 'lingua_finder_parser.treetop'))

  @parser = LinguaFinderParser.new

  def self.parse(data)
    tree = @parser.parse(data.strip)

    raise "Parse error at offset: #{@parser.index}" if tree.nil?

    clean_tree(tree)

    tree
  end

  def self.clean_tree(root_node)
    return if root_node.nil?

    root_node.elements.delete_if { |n| n.instance_of?(Treetop::Runtime::SyntaxNode) }
    root_node.elements.each { |n| clean_tree(n) }
  end
end
