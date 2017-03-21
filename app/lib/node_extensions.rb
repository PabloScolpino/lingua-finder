module LinguaFinder
  class BaseNode < Treetop::Runtime::SyntaxNode
    def strings
      elements.map do |element|
        element.strings
      end.compact
    end

    def pattern
      content
    end

    def content
      input[interval]
    end

    def has_child?(class_name)
      self.class == class_name
    end
  end

  class QueryNode < BaseNode
    def strings
      list = []

      tree = elements.map { |e| e.strings }.compact
      first = tree.shift
      first.product(*tree).each do |combination|
        list << start_token + combination.join(' ') + end_token
      end
      list
    end

    def pattern
      p = elements.map { |e| e.pattern }.compact.join(space_pattern)
      Regexp.new(p)
    end

    def valid?
      has_child?(TargetNode) \
        && (
          has_child?(StringNode) \
          || has_child?(CategoryNode)
        )
    end

    private

    def has_child?(class_name)
      elements.select { |e| e.has_child?(class_name) }.size > 0
    end

    def start_token
      'allintext:"'
    end

    def end_token
      '"'
    end

    def space_pattern
      '[[:space:]]+'

    end
  end

  class ExpressionNode < BaseNode
    def strings
      raise 'invalid tree' if elements.size > 1
      elements.first.strings
    end

    def pattern
      raise 'invalid tree' if elements.size > 1
      elements.first.pattern
    end

    def has_child?(class_name)
      elements.select { |e| e.has_child?(class_name) }.size > 0
    end
  end

  class CategoryNode < BaseNode
    def strings
      words
    end

    def pattern
      return if words.empty?
      '(' + words.join('|') + ')'
    end

    private

    def words
      list = []
      Word.where(category: category).find_each do |w|
        list << w.phrase
      end
      list.select! { |e| e =~ filter } if has_filter?
      list
    end

    def has_filter?
      !elements[1].nil?
    end

    def filter
      Regexp.new(elements[1].pattern)
    end

    def category
      Category.find_by(name: elements[0].content)
    end
  end

  class CategoryNameNode < BaseNode
  end

  class RegexNode < BaseNode
    def strings
    end

    def pattern
      content[1 .. content.size()-2]
    end
  end

  class TargetNode < BaseNode
    def strings
    end

    def pattern
      p = '(?<target>'
      if elements.size > 0
        p = p + elements.first.pattern + ')' + '([[:space:]]|[[:punct:]])+'
      else
        p = p + '[[:alpha:]]+)'
      end
      p
    end
  end

  class DistanceNode < BaseNode
    def strings
    end
  end

  class StringNode < BaseNode
    def strings
      [ content ]
    end
    def pattern
      content
    end
  end

end
