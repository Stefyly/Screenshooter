class Executor
  def initialize(browser)
    @browser = browser
    @current_state = 0
    @state_count = 0
  end
  attr_reader :state_count

  def next_command
    if @commands[@current_state].first.is_a?(Array)
      @commands[@current_state].each do |current_comand|
        execute_comand(current_comand)
      end
    else
      execute_comand(@commands[@current_state])
    end
    @current_state += 1
  end

  def commands_from_file(block_name)
    obj = YAML.safe_load(File.read(File.join(File.dirname(__FILE__), '../states/'+ block_name + '.yml')))
    @commands = obj['states']
    @state_count = obj['total']
    @current_state = 0
    @block_name = block_name
  rescue Psych::SyntaxError => e
    STDERR.puts "\t Can't parse config file for ".red + block_name.cyan
    STDERR.puts "\t Check conflict line in error message".red
    STDERR.puts e
  end

  # @params commands [String] - contain command and params for this command
  #         command[0] - command name
  #         command[1..n] - command params
  def execute_comand(commands)
    send(commands[0], commands)
  rescue StandardError => e
    STDERR.puts "On block #{@block_name}
                             On state #{@current_state}
                             On call #{commands}".red
    STDERR.puts e
  end

  # replace innerHtml of the element
  # @params cmd[String]
  #   cmd[1] - element selector
  #   cmd[2] - new text
  def replace_text(cmd)
    @browser.execute_script("#{i_html(cmd[1])} = '#{cmd[2]}'")
  end

  def replace_texts(selector, text)
    # @browser.execute_script("document.querySelectorAll('#{selector}').forEach(item => { item.innerHTML = '#{text}'})")
  end

  # remove element from DOM
  # @params cmd[String] with length 2 or 3
  # for length 2
  #   cmd[1] - element css selector
  # for length 3
  #   cmd[1] - number of times that command should be performed
  #   cmd[2] - element selector
  def remove(cmd)
    if cmd.length == 3
      cmd[1].times do
        @browser.execute_script("document.querySelector('#{cmd[2]}').remove()")
      end
    else
      @browser.execute_script("document.querySelector('#{cmd[1]}').remove()")
    end
  end

  # copy element and paste to the end of container element
  # @params cmd[String] with length 3 or 4
  # for length 3
  #   cmd[1] - element css selector
  #   cmd[2] - container css selector
  # for length 4
  #   cmd[1] - number of times that command should be performed
  #   cmd[2] - element css selector
  #   cmd[3] - container css selector
  def copy(cmd)
    if cmd.size == 4
      cmd[1].times do
        @browser.execute_script("#{i_html(cmd[3])} += #{o_html(cmd[2])}")
      end
    else
      @browser.execute_script("#{i_html(cmd[2])} += #{o_html(cmd[1])}")
    end
  end

  # refresh browser page
  def refresh(*)
    # p 'refresh page'
    @browser.refresh
  end

  # simulate click on element
  # @params cmd[String]
  #   cmd[1] - element css selector
  def click(cmd)
    @browser.element(css: cmd[1]).click
  end

  # Dirty implementation of the element replacing method
  # Repalace element using css selector to link
  # @params cmd[String]
  #   cmd[1] - element css selector
  def el_to_link(cmd)
    link = '<a style = \"text-decoration: underline\" class=\"link\"> Link instead of button </a>'
    @browser.execute_script("#{o_html(cmd[1])} = '#{link}' ")
  end

  # add inline style for element
  # @params cmd[String]
  #   cmd[1] - element css selector
  #   cmd[2] - css rules
  def add_style(cmd)
    change_attr(:style, cmd[1], cmd[2])
  end

  # replace existed elements class
  # @params cmd[String]
  #   cmd[1] - element css selector
  #   cmd[2] - new classes
  def replace_class(cmd)
    change_attr(:class, cmd[1], cmd[2])
  end

  # add new class for  existed elements classes
  # @params cmd[String]
  #   cmd[1] - element css selector
  #   cmd[2] - additional class
  def add_class(cmd)
    str = [@browser.element(css: cmd[1]).attribute_value('class'), cmd[2]].join(' ')
    change_attr(:class, cmd[1], str)
  end

  # copy element to begin of the container
  # @params cmd[String]
  #   cmd[1] - element css selector
  #   cmd[2] - container selector
  def add_el_to_begin(cmd)
    @browser.execute_script(" #{i_html(cmd[1])} =
                              #{o_html(cmd[2])} + #{i_html(cmd[1])}
                           ")
  end

  # swap 2 elements in DOM
  # elements should be in the same container
  # @params cmd[String]
  #   cmd[1] - first element selector
  #   cmd[2] - seconde element selector
  def swap_el(cmd)
    @browser.execute_script("
      p = document.querySelector('#{cmd[1]}').parentNode;
      f = document.querySelector('#{cmd[1]}');
      s = document.querySelector('#{cmd[2]}');
      p.insertBefore(s, f);
    ")
  end

  # return innerHTML of the element
  def i_html(selector)
    "document.querySelector('#{selector}').innerHTML"
  end

  # return outerHTML of the element
  def o_html(selector)
    "document.querySelector('#{selector}').outerHTML"
  end

  def change_attr(atr, sel, str)
    @browser.execute_script("document.querySelector('#{sel}')
                                     .setAttribute(\"#{atr}\",\"#{str}\")")
  end
end
