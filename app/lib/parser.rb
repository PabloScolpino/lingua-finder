class Parser
  base_path = File.expand_path(File.dirname(__FILE__))
  require File.join(base_path, 'node_extensions.rb')
  Treetop.load(File.join(base_path, 'lingua_finder_parser.treetop'))

  @@parser = LinguaFinderParser.new

  def self.parse(data)
    tree = @@parser.parse(data.strip)

    if(tree.nil?)
      raise Exception, "Parse error at offset: #{@@parser.index}"
    end

    self.clean_tree(tree)

    return tree
  end

  private
  def self.clean_tree(root_node)
    return if root_node.nil?
    root_node.elements.delete_if { |n| n.class.name == 'Treetop::Runtime::SyntaxNode' }
    root_node.elements.each { |n| self.clean_tree(n) }
  end
end
