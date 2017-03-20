module LinguaFinder
  class BaseNode < Treetop::Runtime::SyntaxNode
    def strings
      elements.map do |element|
        element.strings
      end.compact
    end

    def content
      input[interval]
    end
  end
  class QueryNode < BaseNode
    def strings
      list = []
      tree = super

      first = tree.shift
      first.product(*tree).each do |combination|
        list << start_token + combination.join(' ') + end_token
      end
      list
    end
    private

    def start_token
      'allintext:"'
    end

    def end_token
      '"'
    end
  end

  class ExpressionNode < BaseNode
    def strings
      raise 'invalid tree' if elements.size > 1
      elements.first.strings
    end
  end

  class StringNode < BaseNode
    def strings
      [ content ]
    end
  end

  class CategoryNode < BaseNode
    def strings
      words = []
      Word.where(category: category).find_each do |w|
        words << w.phrase
      end
      words
    end

    private

    def category
      Category.find_by(name: elements[0].content)
    end
  end

  class CategoryNameNode < BaseNode
  end

  class RegexNode < BaseNode
    def strings
    end
  end

  class TargetNode < BaseNode
    def strings
    end
  end

  class DistanceNode < BaseNode
    def strings
    end
  end
end
