require 'd-mark'

module LiterateDMark
  class CodeTranslator < DMark::Translator
    def handle(node, in_pre = false, depth = 0)
      case node
      when String
        if in_pre
          out << node
        end
      when DMark::Parser::ElementNode
        if node.name == 'pre' && depth == 0
          handle_children(node, true, depth + 1)
          out << "\n"
        else
          handle_children(node, false, depth + 1)
        end
      end
    end

    def handle_children(node, in_pre, depth)
      node.children.each { |child| handle(child, in_pre, depth) }
    end
  end

  class HTMLTranslator < DMark::Translator
    def run
      out << header
      @nodes.each do |node|
        handle(node)
      end
      out << footer
      out
    end

    def header
      ''.tap do |s|
        s << '<style>' << "\n"
        s << 'body {' << "\n"
        s << '  padding: 20px;' << "\n"
        s << '  width: 720px;' << "\n"
        s << '  margin: 0 auto;' << "\n"
        s << '}' << "\n"
        s << "\n"
        s << 'code {' << "\n"
        s << '  padding: 2px;' << "\n"
        s << '  background: #eee;' << "\n"
        s << '}' << "\n"
        s << "\n"
        s << 'pre {' << "\n"
        s << '  padding: 10px;' << "\n"
        s << '  background: #eee;' << "\n"
        s << '}' << "\n"
        s << '</style>' << "\n"
      end
    end

    def footer
      ''
    end

    def handle(node)
      case node
      when String
        out << html_escape(node)
      when DMark::Parser::ElementNode
        output_start_tags(node)
        handle_children(node)
        output_end_tags(node)
      end
    end

    def output_start_tags(node)
      out << '<'
      out << node.name

      node.attributes.each_pair do |key, value|
        out << ' '
        out << key.to_s
        out << '="'
        out << value
        out << '"'
      end

      out << '>'
    end

    def output_end_tags(node)
      out << '</'
      out << node.name
      out << '>'
    end

    def html_escape(string)
      string
        .gsub('&', '&amp;')
        .gsub('<', '&lt;')
        .gsub('>', '&gt;')
        .gsub('"', '&quot;')
    end
  end
end

if ARGV.size != 1
  $stderr.puts "Usage: #{$0} [filename]"
  exit 1
end

unless File.file?(ARGV[0])
  $stderr.puts "Error: file does not exist: #{ARGV[0]}"
  exit 1
end

if File.extname(ARGV[0]) != '.dmark'
  $stderr.puts "Error: file does not have `.dmark` extension: #{ARGV[0]}"
  exit 1
end

content = File.read(ARGV[0])
nodes = DMark::Parser.new(content).parse

out_basename = File.basename(ARGV[0], File.extname(ARGV[0]))
File.write(out_basename + '-lit.html', LiterateDMark::HTMLTranslator.new(nodes).run)
File.write(out_basename + '-lit.rb', LiterateDMark::CodeTranslator.new(nodes).run)
