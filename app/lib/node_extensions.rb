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

    private

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
      list
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
      content
    end
  end

  class TargetNode < BaseNode
    def strings
    end

    def pattern
      '(?<target>[[:alpha:]]+)'
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
