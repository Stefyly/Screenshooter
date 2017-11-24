class Executor
  def initialize(browser)
    @browser = browser
    @current_state = 0
    @state_count = 0
  end
  attr_reader :state_count

  def next_command
    if @comands[@current_state].first.is_a?(Array)
      @comands[@current_state].each do |current_comand|
        execute_comand(current_comand)
      end
    else
      execute_comand(@comands[@current_state])
    end
    @current_state += 1
  end

  def commands_from_file(block_name)
    obj = YAML.safe_load(File.read(File.join(File.dirname(__FILE__), '../states/' + parse_filename(block_name))))
    @comands = obj['states']
    @state_count = obj['total']
    @current_state = 0
    @block_name = block_name
  end

  def execute_comand(cmd)
    send(cmd[0], cmd)
  rescue StandardError => e
    STDERR.puts "\e[31mERROR On block #{@block_name}
                             On state #{@current_state}
                             On call #{cmd} \e[0m
                             "
    STDERR.puts e
  end

  def replace_text(cmd)
    # p 'set_text selector:' + selector + 'text' + text
    @browser.execute_script("#{i_html(cmd[1])} = '#{cmd[2]}'")
  end

  def replace_texts(selector, text)
    # @browser.execute_script("document.querySelectorAll('#{selector}').forEach(item => { item.innerHTML = '#{text}'})")
  end

  def remove(cmd)
    # p 'remove ' + selector
    if cmd.length == 3
      cmd[1].times do
        @browser.execute_script("document.querySelector('#{cmd[2]}').remove()")
      end
    else
      @browser.execute_script("document.querySelector('#{cmd[1]}').remove()")
    end
  end

  def copy(cmd)
    if cmd.size == 4
      cmd[1].times do
        @browser.execute_script("#{i_html(cmd[2])} += #{o_html(cmd[3])}")
      end
    else
      @browser.execute_script("#{i_html(cmd[1])} += #{o_html(cmd[2])}")
    end
  end

  def refresh(*)
    # p 'refresh page'
    @browser.refresh
  end

  def click(cmd)
    @browser.element(css: cmd[1]).click
  end

  # Dirty implementation of the element replacing method
  def el_to_link(cmd)
    link = '<a style = \"text-decoration: underline\" class=\"link\"> Link instead of button </a>'
    @browser.execute_script("#{o_html(cmd[1])} = '#{link}' ")
  end

  def add_style(cmd)
    change_attr(:style, cmd[1], cmd[2])
  end

  def replace_class(cmd)
    change_attr(:class, cmd[1], cmd[2])
  end

  def add_class(cmd)
    str = [@browser.element(css: cmd[1]).attribute_value('class'), cmd[2]].join(' ')
    change_attr(:class, cmd[1], str)
  end

  def add_el_to_begin(cmd)
    @browser.execute_script(" #{i_html(cmd[1])} =
                              #{o_html(cmd[2])} + #{i_html(cmd[1])}
                           ")
  end

  # swap 2 elements in DOM
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

  def parse_filename(str)
    str.split('/')[1] + '_' + /[0-9]/.match(str).to_s + '.yml'
  end
end
